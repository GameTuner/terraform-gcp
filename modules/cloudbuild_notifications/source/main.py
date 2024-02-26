import base64
import json
import os

import requests

status_text_map = {
    'QUEUED': [':large_yellow_circle:', 'Started build for'],
    'SUCCESS': [':large_green_circle:', 'Finished build for'],
    'FAILURE': [':red_circle:', 'Failed build for'],
    'INTERNAL_ERROR': [':red_circle:', 'Failed build for'],
    'TIMEOUT': [':red_circle:', 'Build timeout for'],
}


def subscribe(event, context):
    build = event_to_build(event['data'])
    service = get_service(build)
    if not service:
        return

    if build['status'] not in status_text_map:
        return

    if 'SLACK_WEBHOOK_URL' not in os.environ:
        return
    
    requests.post(os.environ['SLACK_WEBHOOK_URL'], json=
    {"blocks": [
        {"type": "section",
         "text": {"type": "mrkdwn", "text": f"{status_text_map[build['status']][0]}{get_service_icon(build)}{status_text_map[build['status']][1]} *{service}*\n*<{build['logUrl']}|Go to CloudBuild>*"}}]})


def get_service(build):
    if 'substitutions' in build and '_SERVICE' in build['substitutions']:
        return build['substitutions']['_SERVICE']
    return None


def get_service_icon(build):
    if 'substitutions' in build and '_SLACK_NOTIFICATION_ICON' in build['substitutions']:
        return build['substitutions']['_SLACK_NOTIFICATION_ICON']
    return ''


def event_to_build(data):
    decoded_data = base64.b64decode(data).decode('utf-8')
    return json.loads(decoded_data)
