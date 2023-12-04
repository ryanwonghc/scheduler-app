import requests
import boto3
import config

# r=requests.get("https://zztjxk75ik.execute-api.us-east-1.amazonaws.com/prod/tasks", headers={"Authorization":"eyJraWQiOiJLWVwvRnhnUm04cU9BSXRtNm1wMVwvdmNaSERvdDV0NVc1cWgwRytHNmhrcW89IiwiYWxnIjoiUlMyNTYifQ.eyJhdF9oYXNoIjoiY3Rzc3RBdHZQWEZiMnRNdzR1RWNGQSIsInN1YiI6IjE5ZDUyNTU5LTU3NWUtNGU2MC05YTc4LTU0OTRiYTYwZmRhOCIsImF1ZCI6IjRsaTg1dWkzcTZyNmZqamwxYXFlY2FqY2poIiwiZXZlbnRfaWQiOiJmZTQxYWMxMy05NWE0LTRjZmYtOTUzMC05YWQ1ODIzYzVhMTgiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTcwMTY1NzUyMiwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfeHRJM0xkNHJ3IiwiY29nbml0bzp1c2VybmFtZSI6IlJ5YW5Xb25nIiwiZXhwIjoxNzAxNjYxMTIyLCJpYXQiOjE3MDE2NTc1MjIsImp0aSI6Ijg3YjYzYmMxLTA0YTgtNGExNS1hMDQzLTgzNDdkNDBmMWU0NCJ9.o1Jv0R21sUhrduo5CGTJrqduzs48NxKrOAwFoM4y78j2KTLJKb8GbeCMStjs82yEyvf9t2tnWm7ZZr5IB9dzcZqIKedsVYwl_pGPtn12of3Dow2t8beE9l388cO1m92p2Ejnf7eJkmVgOzAg4i8fXo8OIMjjVdfQiCAZ50MLEa-ByJlum_gaca0GZjL2WEugNsaiawkw0mY3FxkfDJFmYTuPFycsZKjLJCTZ-NKCQqyiubTcHf7gHeJxK6dTMa2iyZ0g3aWovJskNrrBwWFZ4rxdXstdBmBTR_ZRO4qF9o3yNIqC7PMUngysupExQgRG3oe-nLzTusozwbyQ3OYI-Q"})
# print(r.json())
# print(r.text)


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