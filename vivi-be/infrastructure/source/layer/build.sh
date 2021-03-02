## create a python virtual environment and pip3 install the required packages before exporting the requirements file.
# python3 -m venv venv
# . venv/bin/activate
# pip3 install [.....]
# pip3 freeze > requirements.txt
# deactivate
# rm -R venv

## create the required, empty, directory structure
mkdir -p tozip/python/lib/python3.8/site-packages/

## build everything in the requirements.txt using the lambda docker image 
## this ensures all necessary packages are part of it and the aforementioned directory structure.

docker run -v "$PWD":/var/task "lambci/lambda:build-python3.8" /bin/sh -c "pip install -r requirements.txt -t tozip/python/lib/python3.8/site-packages/; exit"

## zip the directory tree and upload as a lambda layer... or do nothing and let terraform handle that.

