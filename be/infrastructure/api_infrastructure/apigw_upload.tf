
resource "aws_api_gateway_resource" "upload_resource" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	parent_id = aws_api_gateway_rest_api.api.root_resource_id
	path_part = "upload"
}

resource "aws_api_gateway_method" "upload_method" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id = aws_api_gateway_resource.upload_resource.id
	http_method = "GET"
	authorization = "NONE"
}

resource "aws_api_gateway_integration" "upload_integration" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id	= aws_api_gateway_resource.upload_resource.id
	http_method = aws_api_gateway_method.upload_method.http_method
	integration_http_method = "POST"
	type = "AWS_PROXY"
	uri = aws_lambda_function.apigw-upload-ul-lambda.invoke_arn
	}
	


resource "aws_api_gateway_method_settings" "upload_general_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.alpha.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled        = true
    data_trace_enabled     = true
    logging_level          = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}


	

