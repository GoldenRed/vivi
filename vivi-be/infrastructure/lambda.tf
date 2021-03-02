# LAMBDA


## Upload Lambda func

data "archive_file" "lambda_zip" {
	type = "zip"
	source_dir = "source/lambda"
	output_path = "lambda.zip"
}


resource "aws_lambda_function" "lambda" {
	filename = "lambda.zip"
	function_name = "lambda"
	role = aws_iam_role.lambda_role.arn
	handler = "lambda.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.lambda_zip.output_base64sha256
	layers = [aws_lambda_layer_version.lambda_layer.arn]
}

data "archive_file" "lambda_layer_zip" {
	type = "zip"
	source_dir = "source/layer/tozip"
	output_path = "lambda_layer.zip"
}

resource "aws_lambda_layer_version" "lambda_layer" {
	filename   = "lambda_layer.zip"
	layer_name = "search_es_lambda_layer"
	compatible_runtimes = ["python3.8"]
	source_code_hash = data.archive_file.lambda_layer_zip.output_base64sha256
}



# IAM

resource "aws_lambda_permission" "apigw_lambda" {
	statement_id = "AllowExecutionFromAPIGateway"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda.function_name
	principal = "apigateway.amazonaws.com"

	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*" 
}

# ${aws_api_gateway_method.method.http_method}/${aws_api_gateway_resource.resource.path}"


resource "aws_iam_role" "lambda_role" {
	name = "apigw-lambda-role"

	assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  	"Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
