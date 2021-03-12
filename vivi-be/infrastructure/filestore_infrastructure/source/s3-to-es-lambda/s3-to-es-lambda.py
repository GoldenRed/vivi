import json
import os

def handler(event, context):
    
    msg = json.loads(event['Records'][0]['Sns']['Message'])
    bucket = msg['Records'][0]['s3']['bucket']['name']
    key = msg['Records'][0]['s3']['object']['key']
    
    data = getDetails(bucket, key)
    uploadToEs(os.environ['es_domain_url'], data)    

def getDetails(bucket, key):
    return data

def uploadToEs(url, data):
    return
