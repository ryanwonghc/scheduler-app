import json
import config

def lambda_handler(event, context):
    # Extract the Authorization header from the incoming request
    authorization_header = event.get('headers', {}).get('Authorization', '')

    principalId = 'user'
    version = '2012-10-17'
    resource = event['methodArn']

    if authorization_header == config.ID_TOKEN:
        action = 'Allow'
    else:
        action = 'Deny'
    
    response = AuthResponse(principalId, version, action, resource)
    authResponse = response.buildResponse()
    return authResponse

    # # Check if the Authorization header contains a valid API key
    # if authorization_header == config.ID_TOKEN:
    #     # Authorization successful
    #     response = {
    #         'principalId': 'user',
    #         'policyDocument': {
    #             'Version': '2012-10-17',
    #             'Statement': [
    #                 {
    #                     'Action': 'execute-api:Invoke',
    #                     'Effect': 'Allow',
    #                     'Resource': event['methodArn']
    #                 }
    #             ]
    #         }
    #     }
    # else:
    #     # Authorization failed
    #     response = {
    #         'principalId': 'user',
    #         'policyDocument': {
    #             'Version': '2012-10-17',
    #             'Statement': [
    #                 {
    #                     'Action': 'execute-api:Invoke',
    #                     'Effect': 'Deny',
    #                     'Resource': event['methodArn']
    #                 }
    #             ]
    #         }
    #     }

    # return response

class AuthResponse:
    def __init__(self, principalId, version, action, resource):
        self.principalId = principalId
        self.version = version
        self.action = action
        self.resource = resource
    
    def buildResponse(self):
        response = {
            'principalId': self.principalId,
            'policyDocument': {
                'Version': self.version,
                'Statement': [
                    {
                        'Action': 'execute-api:Invoke',
                        'Effect': self.action,
                        'Resource': self.resource
                    }
                ]
            }
        }

        return response