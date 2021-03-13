import boto3
from botocore.exceptions import ClientError
import json


def update_item(user_name: str, tag_id: str, new_tag_name: str) -> dict:
    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('bookmark_list_tag')

    try:
        response = table.update_item(
            Key={
                'userName': user_name,
                'tagID': tag_id
            },
            UpdateExpression="SET tagName=:n",
            ExpressionAttributeValues={
                ':n': new_tag_name
            },
            ReturnValues="UPDATED_OLD"
        )
        return response
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise


def lambda_handler(event: dict, context):
    request_body: dict = json.loads(event['body'])

    user_name: str = event['pathParameters']['userName']
    tag_id: str = event['pathParameters']['tagID']
    new_tag_name = request_body['newName']

    try:
        response = update_item(user_name=user_name,
                               tag_id=tag_id, new_tag_name=new_tag_name)

        if 'Attributes' not in response:
            return {
                'statusCode': 201,
            }

        return {
            'statusCode': 204,
        }
    except ClientError as e:
        return {
            'statusCode': 500,
        }
