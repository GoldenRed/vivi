resource "aws_s3_bucket" "uploadlimbo" {
	bucket_prefix = join("-", [var.project, "upload", "limbo", var.environment])
	tags = {
		Name = "Upload Limbo"
		Project = var.project
		Environment = var.environment
	}
}

