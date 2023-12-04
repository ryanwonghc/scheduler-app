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
    if event['httpMethod'] == 'GET' and event['path'] == '/prod/task':
        response = getTask(event['queryStringParameters']['TaskId'])
    elif event['httpMethod'] == 'GET' and event['path'] == '/prod/tasks':
        response = getTasks()
    else:
        response = buildResponse(404, 'Not Found')
    return response
    
def getTask(taskId):
    try:
        response = table.get_item(
            Key = { 'UserId': 'ryanwong', 'TaskId': taskId }
        )
        if 'Item' in response:
            return buildResponse(200, response['Item'])
        else:
            return buildResponse(404, {'Message': 'TaskId {0} not found'.format(taskId)})    
    except:
        logger.exception("get_item failed")

def getTasks():
    try:
        response = table.scan()
        result = response['Items']

        while 'LastEvaluatedKey' in response:
            response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
            result.extend(response['Items'])
        
        body = { 'tasks': response }

        return buildResponse(200, body)
    except:
        logger.exception("scan failed")

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