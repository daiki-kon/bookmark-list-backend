import boto3
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


def put_item(userName: str, bookmark_id: str, bookmark_url: str, tag_id_list: List[str], registered_date: str) -> None:
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(bookmark_dynamoDB_table_name)
    response = table.put_item(
        Item={
            'userName': userName,
            'bookmarkID': str(uuid4()),
            'bookmarkURL': bookmark_url,
            'registeredDate': registered_date,
            'tagIDs': tag_id_list
        }
    )
    return response


def lambda_handler(event: dict, context):
    userName: str = event['pathParameters']['userName']
    request_body: dict = json.loads(event['body'])
    bookmark_url: str = request_body['bookmarkURL']
    tag_id_list: List[str] = request_body['tagsIDs']
    bookmark_id: str = str(uuid4())
    registered_date: str = get_current_jst()

    put_item(userName=userName, bookmark_id=bookmark_id, bookmark_url=bookmark_url,
             tag_id_list=tag_id_list, registered_date=registered_date)

    response_body = {
        'data': {
            'bookmarkID': bookmark_id,
            'registeredDate': registered_date
        }
    }

    return {
        'statusCode': 201,
        'body': json.dumps(response_body)
    }
