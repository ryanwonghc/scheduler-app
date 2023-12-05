import requests
import boto3
import config




logn = boto3.client('cognito-idp')
res = logn.initiate_auth(
            ClientId=config.CLIENT_ID,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': config.USERNAME,
                'PASSWORD': config.PASSWORD
            }
        )
print(res)
print(res['AuthenticationResult']['AccessToken'])

r=requests.get("https://zztjxk75ik.execute-api.us-east-1.amazonaws.com/prod/tasks", headers={"Authorization":res['AuthenticationResult']['AccessToken'],"TaskId":"1"})
print(r.json())
print(r.text)