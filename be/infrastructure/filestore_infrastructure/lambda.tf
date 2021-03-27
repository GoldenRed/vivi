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
	handler = "s3-to-es-lambda.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.s3-to-es_lambda_zip.output_base64sha256

	depends_on = [
		aws_iam_role_policy_attachment.lambda_logs
	]
	
	environment {
		variables = {
			es_domain_url = var.es_url
			}
		}
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
	handler = "s3-to-ddb-lambda.handler"
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

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
	role = aws_iam_role.lambda_role.name
	policy_arn = aws_iam_policy.lambda_logging.arn
}
