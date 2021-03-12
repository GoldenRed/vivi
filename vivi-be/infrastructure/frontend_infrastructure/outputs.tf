
output "frontend_bucket_id" {
	value = aws_s3_bucket.frontend.website_endpoint
}
