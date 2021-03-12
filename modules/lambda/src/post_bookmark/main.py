import boto3
from botocore.exceptions import ClientError
import json
import os
from datetime import datetime, timedelta, timezone
from typing import List
from uuid import uuid4

bookmark_dynamoDB_table_name = os.environ['bookmark_dynamoDB_table_name']


def utc_to_jst(timestamp_utc: str) -> str:
    datetime_utc = datetime.strptime(timestamp_utc, '%Y-%m-%dT%H:%M%z')
    datetime_jst = datetime_utc.astimezone(timezone(timedelta(hours=+9)))
    timestamp_jst = datetime.strftime(
        datetime_jst, '%Y-%m-%dT%H:%M' + '+09:00')
    return timestamp_jst


def get_current_jst() -> str:
    date_now = datetime.now(tz=timezone.utc)
    date_now_iso = date_now.isoformat(timespec='minutes')
    return utc_to_jst(date_now_iso)


def put_item(user_name: str, bookmark_id: str, bookmark_url: str, tag_id_list: List[str], registered_date: str) -> dict:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(bookmark_dynamoDB_table_name)

    try:
        response = table.put_item(
            Item={
                'userName': user_name,
                'bookmarkID': str(uuid4()),
                'bookmarkURL': bookmark_url,
                'registeredDate': registered_date,
                'tagIDs': tag_id_list
            }
        )
    except ClientError as e:
        raise

    return response


def lambda_handler(event: dict, context):
    user_name: str = event['pathParameters']['userName']
    request_body: dict = json.loads(event['body'])
    bookmark_url: str = request_body['bookmarkURL']
    tag_id_list: List[str] = request_body['tagsIDs']
    bookmark_id: str = str(uuid4())
    registered_date: str = get_current_jst()

    put_item(user_name=user_name, bookmark_id=bookmark_id, bookmark_url=bookmark_url,
             tag_id_list=tag_id_list, registered_date=registered_date)

    try:
        response_body = {
            'data': {
                'bookmarkID': bookmark_id,
                'registeredDate': registered_date
            }
        }
    except ClientError:
        return {
            'statusCode': 500,
        }

    return {
        'statusCode': 201,
        'body': json.dumps(response_body)
    }
