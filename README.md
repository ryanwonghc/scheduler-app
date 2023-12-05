# scheduler-app

![Infrastructure](/images/scheduler_app_stack.png)

1. User login via Cognito
2. Cognito returns id_token to client
3. User sends request to API Gateway with token
4. Cognito verifies token
5. API Gateway sends request to lambda function
6. Lambda function interacts with DynamoDB and provides user with response