resource "aws_s3_bucket" "filestore" {
	bucket_prefix = join("-", [var.project, "file", "store", var.environment])
	tags = {
		Name = "File Store"
		Project = var.project 
		Environment = var.environment
	}
}


resource "aws_s3_bucket_notification" "bucket_notification" {
	bucket = aws_s3_bucket.filestore.id

	topic {
		topic_arn = aws_sns_topic.s3-upload-topic.arn
		events = ["s3:ObjectCreated:*"]
	}
}
