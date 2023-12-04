import os
import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DB_NAME = os.environ['TASK_DB_NAME']

def lambda_handler(event, context):
    return