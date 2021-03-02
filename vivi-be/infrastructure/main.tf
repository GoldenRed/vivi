provider "aws" {
	region = var.region
}



## Get account id stuff 

data "aws_caller_identity" "current" {}

