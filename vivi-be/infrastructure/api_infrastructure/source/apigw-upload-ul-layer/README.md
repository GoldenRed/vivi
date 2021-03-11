# The Lambda Layers

## Step 1: Build your requirements.txt file
Based off of your lambda function, create a requirements.txt file using:

```
python3 -m venv venv
. venv/bin/activate
pip3 install [...]
pip3 freeze > requirements.txt
deactivate
rm -R venv
``

Use pip3 to install all the required packages you might need. Remember that there is a hard limit of 250mb on lambda layer size.

## Step 2: Build the python/lib/python3.8/site-packages directory under tozip/

We use the docker image for Lambda to create this, ensuring that the lambda environment specific stuff get included.

Just run ./build_layer.sh to trigger it.

It requires docker to be installed.


## Step 3: Deploying to AWS

The lambda.tf terraform file contains two pieces of terraform packages. One is a "data" type that will zip everything under tozip.

The resulting lambda_layer.zip that gets uploaded is stored in the infrastructure directory.

