import boto3
from botocore.exceptions import ClientError
import json, os, uuid, logging

def handler(event, context):
    s3_client = boto3.client('s3')
    try:
        s3_response = boto3.client('s3').generate_presigned_post(os.environ['upload_bucket'], str(uuid.uuid4()), ExpiresIn=900)
    except ClientError as e:
        logging.error(e)
        return {
            'isBase64Encoded': False,
            'statusCode': 404,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': context.aws_request_id
        }


        
    return {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        },
        'body': json.dumps(s3_response)
    }

     