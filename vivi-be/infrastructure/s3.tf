resource "aws_s3_bucket" "filestore" {
	bucket_prefix = join("-", [var.project, "filestore", var.environment])
	tags = {
		Name = "filestore"
		Project = var.project 
		Environment = var.environment
	}
}

