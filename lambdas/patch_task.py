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
    if event['httpMethod'] == 'PATCH' and event['path'] == '/prod/task':
        requestBody = json.loads(event['body'])
        response = updateTask(requestBody['TaskId'],requestBody['updateKey'],requestBody['updateValue'])
    else:
        response = buildResponse(404, 'Not Found')
    return response

def updateTask(taskId, updateKey, updateValue):
    try:
        response = table.update_item(
            Key = {
                'UserId': 'ryanwong',
                'TaskId': taskId
            },
            UpdateExpression = "SET {updateKey} = :value".format(updateKey=updateKey),
            ExpressionAttributeValues={
                ':value': updateValue
            },
            ReturnValues='UPDATED_NEW'
        )
        responseBody = {
            'Operation': 'PATCH',
            'Message': 'SUCCESS',
            'UpdatedAttributes': response
        }
        return buildResponse(200, responseBody)
    except:
        logger.exception("update_item failed")

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