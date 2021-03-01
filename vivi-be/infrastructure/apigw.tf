resource "aws_api_gateway_rest_api" "api" {
	name = join("-", [var.project, "search", "API"])
	description = "API endpoint installed in front of the Amazon Elasticsearch domain."
	}

resource "aws_api_gateway_resource" "resource" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	parent_id = aws_api_gateway_rest_api.api.root_resource_id
	path_part = "resource"
}

resource "aws_api_gateway_method" "method" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id = aws_api_gateway_resource.resource.id
	http_method = "GET"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id	= aws_api_gateway_resource.resource.id
	http_method = aws_api_gateway_method.method.http_method
	integration_http_method = "POST"
	type = "AWS_PROXY"
	uri = aws_lambda_function.lambda.invoke_arn
}

# LAMBDA

resource "aws_lambda_permission" "apigw_lambda" {
	statement_id = "AllowExecutionFromAPIGateway"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda.function_name
	principal = "apigateway.amazonaws.com"

	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}/${aws_api_gateway_resource.resource.path}"

}

data "archive_file" "lambda_zip" {
	type = "zip"
	source_dir = "source"
	output_path = "lambda.zip"
}


resource "aws_lambda_function" "lambda" {
	filename = "lambda.zip"
	function_name = "mylambda"
	role = aws_iam_role.role.arn
	handler = "lambda.lambda_handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# IAM

resource "aws_iam_role" "role" {
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


