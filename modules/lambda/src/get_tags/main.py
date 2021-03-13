import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError
import json
import os

tag_dynamodb_table_name = os.environ['tag_dynamodb_table_name']


def query_user_tag(user_name: str) -> dict:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tag_dynamodb_table_name)

    try:
        response = table.query(
            KeyConditionExpression=Key('userName').eq(user_name),
            ProjectionExpression='tagID,tagName'
        )
        print(response)
        return [
            {
                'tagID': item['tagID'],
                'tagName': item['tagName']
            }for item in response["Items"]
        ]
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise


def lambda_handler(event: dict, context):
    user_name: str = event['pathParameters']['userName']

    try:
        response_body = {
            'data': query_user_tag(user_name)
        }

        return {
            'statusCode': 200,
            'body': json.dumps(response_body)
        }
    except ClientError:
        return {
            'statusCode': 500,
        }
