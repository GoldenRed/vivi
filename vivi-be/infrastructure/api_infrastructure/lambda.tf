# LAMBDA


## Upload Lambda func

data "archive_file" "lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/apigw-search-es-lambda"
	output_path = "${path.module}/apigw-search-es-lambda.zip"
}


resource "aws_lambda_function" "apigw-search-es-lambda" {
	filename = "${path.module}/apigw-search-es-lambda.zip"
	function_name = "apigw-search-es-lambda"
	role = aws_iam_role.lambda_role.arn
	handler = "apigw-search-es-lambda.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.lambda_zip.output_base64sha256
	layers = [aws_lambda_layer_version.apigw-search-es-layer.arn]
}

data "archive_file" "apigw-search-es-layer_zip" {
	type = "zip"
	source_dir = "${path.module}/source/apigw-search-es-layer/tozip"
	output_path = "${path.module}/apigw-search-es-layer.zip"
}

resource "aws_lambda_layer_version" "apigw-search-es-layer" {
	filename   = "${path.module}/apigw-search-es-layer.zip"
	layer_name = "search_es_lambda_layer"
	compatible_runtimes = ["python3.8"]
	source_code_hash = data.archive_file.apigw-search-es-layer_zip.output_base64sha256
}



# IAM

resource "aws_lambda_permission" "apigw_lambda" {
	statement_id = "AllowExecutionFromAPIGateway"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.apigw-search-es-lambda.function_name
	principal = "apigateway.amazonaws.com"

	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*" 
}

# ${aws_api_gateway_method.method.http_method}/${aws_api_gateway_resource.resource.path}"


resource "aws_iam_role" "lambda_role" {
	name = "api-infrastructure-lambda-role"

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
