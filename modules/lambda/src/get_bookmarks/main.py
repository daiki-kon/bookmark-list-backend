import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import json
from itertools import chain
import os


bookmark_dynamoDB_table_name = os.environ['bookmark_dynamoDB_table_name']
tag_dynamodb_table_name = os.environ['tag_dynamodb_table_name']


def query_user_name(user_name: str) -> dict:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(bookmark_dynamoDB_table_name)

    try:
        response = table.query(
            KeyConditionExpression=Key('userName').eq(user_name),
            ProjectionExpression='tagIDs,bookmarkURL,bookmarkID,registeredDate'
        )
        return response["Items"]
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise


def create_unique_tag_list(tag_list: list) -> list:
    flat_tag_list = list(chain.from_iterable(tag_list))
    return list(set(flat_tag_list))


def create_tag_hash(tag_list: list, user_name: str) -> dict:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tag_dynamodb_table_name)

    try:
        response = table.query(
            KeyConditionExpression=Key('userName').eq(user_name),
            ProjectionExpression='tagID,tagName'
        )
        return {item['tagID']: item['tagName'] for item in response["Items"]}
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise


def lambda_handler(event: dict, context):
    user_name: str = event['pathParameters']['userName']

    try:
        query_response = query_user_name(user_name=user_name)
        tag_id_list = [item['tagIDs'] for item in query_response]
        unique_tag_list = create_unique_tag_list(tag_id_list)
        tag_hash = create_tag_hash(
            tag_list=unique_tag_list, user_name=user_name)

        response_body = {
            'data': [
                {
                    'bookmarkID': bookmark['bookmarkID'],
                    'bookmarkURL': bookmark['bookmarkURL'],
                    'registeredDate': bookmark['registeredDate'],
                    'tags':[
                        {
                            'tagID': tag_id,
                            'tag_name': tag_hash[tag_id]
                        }for tag_id in bookmark['tagIDs']
                    ]
                } for bookmark in query_response
            ]
        }

        return {
            'statusCode': 200,
            'body': json.dumps(response_body)
        }

    except ClientError as e:
        return {
            'statusCode': 500,
        }
    except KeyError as e:
        return {
            'statusCode': 500,
        }
