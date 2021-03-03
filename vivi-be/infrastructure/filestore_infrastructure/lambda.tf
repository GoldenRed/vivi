# LAMBDA


## Upload Lambda func

data "archive_file" "s3-to-es_lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/s3-to-es-lambda"
	output_path = "${path.module}/s3-to-es_lambda.zip"
}


resource "aws_lambda_function" "s3-to-es" {
	filename = "${path.module}/s3-to-es_lambda.zip"
	function_name = "s3-to-es"
	role = aws_iam_role.lambda_role.arn
	handler = "lambda.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.s3-to-es_lambda_zip.output_base64sha256
}



data "archive_file" "s3-to-ddb_lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/s3-to-ddb-lambda"
	output_path = "${path.module}/s3-to-ddb_lambda.zip"
}


resource "aws_lambda_function" "s3-to-ddb" {
	filename = "${path.module}/s3-to-ddb_lambda.zip"
	function_name = "s3-to-ddb"
	role = aws_iam_role.lambda_role.arn
	handler = "lambda.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.s3-to-ddb_lambda_zip.output_base64sha256
}

# IAM

resource "aws_iam_role" "lambda_role" {
	name = "filestore-infrastructure-lambda-role"

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
