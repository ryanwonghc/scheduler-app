import os
import json
import boto3
import logging
import json
from decimal import Decimal

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DB_NAME = os.environ['TASK_DB_NAME']
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DB_NAME)

def lambda_handler(event, context):
    logger.info(event)
    if event['httpMethod'] == 'DELETE' and event['path'] == '/prod/task':
        requestBody = json.loads(event['body'])
        response = deleteTask(requestBody['TaskId'])
    else:
        response = buildResponse(404, 'Not Found')
    return response

def deleteTask(taskId):
    try:
        response = table.delete_item(
            Key = {
                'UserId': 'ryanwong',
                'TaskId': taskId
            },
            ReturnValues='ALL_OLD'
        )
        responseBody = {
            'Operation': 'DELETE',
            'Message': 'SUCCESS',
            'DeletedTask': response
        }
        return buildResponse(200, responseBody)
    except:
        logger.exception("delete_item failed")

class CustomEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        
        return json.JSONEncoder.default(self.obj)
    
def buildResponse(statusCode, body=None):
    response = {
        'statusCode':statusCode,
        'headers':{
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }

    if body is not None:
        response['body'] = json.dumps(body, cls=CustomEncoder)
    
    return response