import requests
from bs4 import BeautifulSoup
import json


def lambda_handler(event: dict, context):
    url: str = event['pathParameters']['url']
    res = requests.get(url)

    soup = BeautifulSoup(res.text, 'html.parser')

    og_img = soup.find('meta', attrs={'property': 'og:image', 'content': True})
    og_title = soup.find(
        'meta', attrs={'property': 'og:title', 'content': True})
    og_site_name = soup.find(
        'meta', attrs={'property': 'og:site_name', 'content': True})

    response_body = {
        'data': {
            'ogSiteName': og_site_name['content'] if og_img is not None else '',
            'ogTitle': og_title['content'] if og_img is not None else '',
            'ogImageURL': og_img['content'] if og_img is not None else ''
        }
    }

    return {
        'statusCode': 200,
        'body': json.dumps(response_body)
    }
