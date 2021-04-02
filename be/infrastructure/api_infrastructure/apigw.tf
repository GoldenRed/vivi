resource "aws_api_gateway_rest_api" "api" {
	name = join("-", [var.project, "API"])
	description = "The API Gateway for ${var.project}."
	}



resource "aws_api_gateway_account" "demo" {
	cloudwatch_role_arn = aws_iam_role.cloudwatch_role.arn
}

resource "aws_api_gateway_stage" "alpha"  {
	deployment_id = aws_api_gateway_deployment.deployment_alpha.id
	rest_api_id = aws_api_gateway_rest_api.api.id
	stage_name = "alpha"
 }

resource "aws_api_gateway_deployment" "deployment_alpha" {
	rest_api_id = aws_api_gateway_rest_api.api.id

	triggers = { #https://github.com/hashicorp/terraform-provider-aws/issues/162
		redeployment = sha1(jsonencode([
		  aws_api_gateway_resource.upload_resource,
		  aws_api_gateway_method.upload_method,
		  aws_api_gateway_integration.upload_integration,
		  aws_api_gateway_resource.search_resource,
		  aws_api_gateway_method.search_method,
		  aws_api_gateway_integration.search_integration,
		  aws_api_gateway_resource.getitem_resource,
		  aws_api_gateway_method.getitem_method,
		  aws_api_gateway_integration.getitem_integration,
		]))
	
	}
	
	lifecycle {
		create_before_destroy = true
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


