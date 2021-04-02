# LAMBDA


## Upload Lambda func


### SEARCH API LAMBDA
data "archive_file" "search-es-lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/apigw-search-es-lambda"
	output_path = "${path.module}/apigw-search-es-lambda.zip"
}


resource "aws_lambda_function" "apigw-search-es-lambda" {
	filename = "${path.module}/apigw-search-es-lambda.zip"
	function_name = "apigw-search-es-lambda"
	role = aws_iam_role.search_es_lambda_role.arn
	handler = "apigw-search-es.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.search-es-lambda_zip.output_base64sha256
	layers = [aws_lambda_layer_version.apigw-search-es-layer.arn]

	environment {
		variables = {
			es_domain_url = var.es_url
			}
		}
}

#### GET INDIVIDUAL DOC LAMBDA, Use the same layer as the search
data "archive_file" "getitem-es-lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/apigw-getitem-es-lambda"
	output_path = "${path.module}/apigw-getitem-es-lambda.zip"
}


resource "aws_lambda_function" "apigw-getitem-es-lambda" {
	filename = "${path.module}/apigw-getitem-es-lambda.zip"
	function_name = "apigw-getitem-es-lambda"
	role = aws_iam_role.getitem_es_lambda_role.arn
	handler = "apigw-getitem-es.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.getitem-es-lambda_zip.output_base64sha256
	layers = [aws_lambda_layer_version.apigw-search-es-layer.arn] ## Just use the same layer

	environment {
		variables = {
			es_domain_url = var.es_url
			}
		}
}


### SEARCH LAYER
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











### the "Submit/Upload" function


data "archive_file" "upload-ul-lambda_zip" {
	type = "zip"
	source_dir = "${path.module}/source/apigw-upload-ul-lambda"
	output_path = "${path.module}/apigw-upload-ul-lambda.zip"
}

resource "aws_lambda_function" "apigw-upload-ul-lambda" {
	filename = "${path.module}/apigw-upload-ul-lambda.zip"
	function_name = "apigw-upload-ul-lambda"
	role = aws_iam_role.upload_ul_lambda_role.arn
	handler = "apigw-upload-ul.handler"
	runtime = "python3.8"
	source_code_hash = data.archive_file.upload-ul-lambda_zip.output_base64sha256
#	layers = [aws_lambda_layer_version.apigw-upload-ul-layer.arn]
	environment {
		variables = {
			upload_bucket = var.upload_bucket
		}
	}

}



#data "archive_file" "apigw-upload-ul-layer_zip" {
#	type = "zip"
#	source_dir = "${path.module}/source/apigw-upload-ul-layer/tozip"
#	output_path = "${path.module}/apigw-upload-ul-layer.zip"
#}

#resource "aws_lambda_layer_version" "apigw-upload-ul-layer" {
#	filename = "${path.module}/apigw-upload-ul-layer.zip"
#	layer_name = "upload_ul_lambda_layer"
#	compatible_runtimes = ["python3.8"]
#	source_code_hash = data.archive_file.apigw-upload-ul-layer_zip.output_base64sha256
#}

### Permisions

resource "aws_lambda_permission" "apigw_search_lambda" {
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.apigw-search-es-lambda.function_name
	principal = "apigateway.amazonaws.com"
	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*" 
}

resource "aws_lambda_permission" "apigw_getitem_lambda" {
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.apigw-getitem-es-lambda.function_name
	principal = "apigateway.amazonaws.com"
	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*" 
}

resource "aws_lambda_permission" "apigw_upload_lambda" {
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.apigw-upload-ul-lambda.function_name
	principal = "apigateway.amazonaws.com"
	source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*"
}


# IAM


## Base Lambda Assume Execution Role Document
data "aws_iam_policy_document" "lambda_sts_assume" {
	statement {
		actions = ["sts:AssumeRole"]
		principals {
			type = "Service"
			identifiers = ["lambda.amazonaws.com"]
		}
		effect = "Allow"
	}

}

resource "aws_iam_role" "search_es_lambda_role" {
	name = "search_es_lambda_role"
	assume_role_policy = data.aws_iam_policy_document.lambda_sts_assume.json
}
resource "aws_iam_role" "getitem_es_lambda_role" {
	name = "getitem_es_lambda_role"
	assume_role_policy = data.aws_iam_policy_document.lambda_sts_assume.json
}

resource "aws_iam_role" "upload_ul_lambda_role" {
	name = "upload_ul_lambda_role"
	assume_role_policy = data.aws_iam_policy_document.lambda_sts_assume.json
}


## Policy JSON Documents
data "aws_iam_policy_document" "lambda_cloudwatch_logs" {
	statement {
		actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
		resources = ["arn:aws:logs:*:*:*"]
	}
}

## ---- ## policy regarding getting s3 presigned url

data "aws_iam_policy_document" "lambda_s3_presigned_url_post" {
	statement {
		actions = ["s3:PutObject"]
		resources = ["arn:aws:s3:::${var.upload_bucket}"]
	}
}

## Create the IAM Policies 
data "aws_iam_policy_document" "search_es_lambda" {
	source_policy_documents = [
		data.aws_iam_policy_document.lambda_cloudwatch_logs.json
		]
}

resource "aws_iam_policy" "combined_search_es_lambda" {
	policy = data.aws_iam_policy_document.search_es_lambda.json
}


data "aws_iam_policy_document" "getitem_es_lambda" {
	source_policy_documents = [
		data.aws_iam_policy_document.lambda_cloudwatch_logs.json
		]
}

resource "aws_iam_policy" "combined_getitem_es_lambda" {
	policy = data.aws_iam_policy_document.getitem_es_lambda.json
}


data "aws_iam_policy_document" "upload_ul_lambda" {
	source_policy_documents = [
		data.aws_iam_policy_document.lambda_cloudwatch_logs.json
		]
}

resource "aws_iam_policy" "combined_upload_ul_lambda" {
	policy = data.aws_iam_policy_document.upload_ul_lambda.json
}

## Attach them all

resource "aws_iam_policy_attachment" "search_es_attach" {
  name       = "search_es_lambda_attachment"
  roles      = [aws_iam_role.search_es_lambda_role.name] 
  policy_arn = aws_iam_policy.combined_search_es_lambda.arn
}

resource "aws_iam_policy_attachment" "getitem_es_attach" {
  name       = "getitem_es_lambda_attachment"
  roles      = [aws_iam_role.getitem_es_lambda_role.name] 
  policy_arn = aws_iam_policy.combined_getitem_es_lambda.arn
}

resource "aws_iam_policy_attachment" "upload_ul_attach" {
  name       = "upload_ul_lambda_attachment"
  roles      = [aws_iam_role.upload_ul_lambda_role.name]
  policy_arn = aws_iam_policy.combined_upload_ul_lambda.arn
}
