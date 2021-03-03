resource "aws_api_gateway_rest_api" "api" {
	name = join("-", [var.project, "search", "API"])
	description = "API endpoint installed in front of the Amazon Elasticsearch domain."
	}

resource "aws_api_gateway_resource" "resource" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	parent_id = aws_api_gateway_rest_api.api.root_resource_id
	path_part = "search"
}

resource "aws_api_gateway_method" "method" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id = aws_api_gateway_resource.resource.id
	http_method = "GET"
	authorization = "NONE"
	request_parameters = {"method.request.querystring.q"=true}
}

resource "aws_api_gateway_integration" "integration" {
	rest_api_id = aws_api_gateway_rest_api.api.id
	resource_id	= aws_api_gateway_resource.resource.id
	http_method = aws_api_gateway_method.method.http_method
	integration_http_method = "POST"
	type = "AWS_PROXY"
	uri = aws_lambda_function.apigw-search-es-lambda.invoke_arn
}

resource "aws_api_gateway_account" "demo" {
	cloudwatch_role_arn = aws_iam_role.cloudwatch_role.arn
}


resource "aws_api_gateway_deployment" "deployment_alpha" {
	rest_api_id = aws_api_gateway_rest_api.api.id

	triggers = { #https://github.com/hashicorp/terraform-provider-aws/issues/162
		redeployment = sha1(jsonencode([
		  aws_api_gateway_resource.resource,
		  aws_api_gateway_method.method,
		  aws_api_gateway_integration.integration,
		]))
	
	}
	
	lifecycle {
		create_before_destroy = true
	}

}

resource "aws_api_gateway_stage" "alpha"  {
	deployment_id = aws_api_gateway_deployment.deployment_alpha.id
	rest_api_id = aws_api_gateway_rest_api.api.id
	stage_name = "alpha"
}


resource "aws_api_gateway_method_settings" "general_settings" {
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



# IAM

resource "aws_iam_role" "cloudwatch_role" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_role" {
	name = "default"
  role = aws_iam_role.cloudwatch_role.id

	policy = <<EOF
{
  "Version": "2012-10-17",
	"Statement": [
	{
		"Effect": "Allow",
		"Action": [
			"logs:CreateLogGroup",
			"logs:CreateLogStream",
			"logs:DescribeLogGroups",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents",
			"logs:GetLogEvents",
			"logs:FilterLogEvents"
			],
		"Resource":"*"
	  }
	 ]
	}
EOF
}


