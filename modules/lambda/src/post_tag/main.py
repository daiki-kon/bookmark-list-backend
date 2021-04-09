import boto3
from botocore.exceptions import ClientError
import json
from uuid import uuid4
import os

tag_dynamodb_table_name = os.environ['tag_dynamodb_table_name']


def put_item(user_name: str, tag_id: str, tag_name: str) -> dict:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tag_dynamodb_table_name)

    try:
        response = table.put_item(
            Item={
                'userName': user_name,
                'tagID': tag_id,
                'tagName': tag_name
            }
        )

        return response
    except ClientError as e:
        raise


def lambda_handler(event: dict, context):
    request_body: dict = json.loads(event['body'])

    user_name: str = event['pathParameters']['userName']
    tag_name: str = request_body['tagName']
    tag_id: str = str(uuid4())

    try:
        put_item(user_name=user_name, tag_id=tag_id, tag_name=tag_name)

        response_body = {
            'id': tag_id,
            'name': tag_name
        }

        return {
            'statusCode': 201,
            'body': json.dumps(response_body)
        }

    except ClientError as e:
        print(e)
        return {
            'statusCode': 500,
        }
