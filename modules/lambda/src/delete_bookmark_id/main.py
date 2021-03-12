import boto3
from botocore.exceptions import ClientError
import json
import os

bookmark_dynamoDB_table_name = os.environ['bookmark_dynamoDB_table_name']

# delete_itemでは削除対象が存在するかわからないので実装
def is_exists_item(user_name: str, bookmark_id: str, table: object) -> bool:
    try:
        response = table.get_item(
            Key={
                'userName': user_name,
                'bookmarkID': bookmark_id
            }
        )

        if "Item" in response:
            return True
        else:
            return False
    except ClientError as e:
        print(e.response['Error']['Message'])
        raise

def delete_item(user_name: str, bookmark_id: str, table: object) -> bool:
    try:
        response = table.delete_item(
            Key={
                'userName': user_name,
                'bookmarkID': bookmark_id
            }
        )

        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            return True
        else:
            return False
    except ClientError as e:
        print(e.response['Error']['Message'])
        return False

def lambda_handler(event: dict, context):
    print(json.dumps(event))
    user_name: str = event['pathParameters']['userName']
    bookmark_id: str = event['pathParameters']['bookmarkID']

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(bookmark_dynamoDB_table_name)

    try:
        if is_exists_item(user_name=user_name, bookmark_id=bookmark_id, table=table) == False:
            return {
                'statusCode': 404
            }
    except ClientError as e:
        return {
            'statusCode': 500
        }

    result = delete_item(user_name=user_name, bookmark_id=bookmark_id, table=table)
    if result == True:
        return {
            'statusCode': 201
        }
    else:
        return {
            'statusCode': 500
        }