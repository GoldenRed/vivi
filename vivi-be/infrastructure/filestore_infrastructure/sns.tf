resource "aws_sns_topic" "s3-upload-topic" {
	name = "s3-event-notification-topic"

	policy = <<POLICY
{
	"Version":"2012-10-17",
	"Statement":[{
		"Effect": "Allow",
		"Principal": { "Service": "s3.amazonaws.com" },
		"Action": "SNS:Publish",
		"Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
		"Condition": {
			"ArnLike":{"aws:SourceArn":"${aws_s3_bucket.filestore.arn}"}
		}
	}]
}
POLICY
}


resource "aws_sns_topic_subscription" "es_lambda_sub" {
	topic_arn = aws_sns_topic.s3-upload-topic.arn
	protocol = "lambda" 
	endpoint = aws_lambda_function.s3-to-es.arn
}


resource "aws_lambda_permission" "with_sns" {
	statement_id = "AllowExecutionFromSNS"
	action ="lambda:InvokeFunction"
	function_name = aws_lambda_function.s3-to-es.arn
	principal = "sns.amazonaws.com"
	source_arn = aws_sns_topic.s3-upload-topic.arn
}
