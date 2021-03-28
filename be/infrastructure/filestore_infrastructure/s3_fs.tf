resource "aws_s3_bucket" "filestore" {
	bucket_prefix = join("-", [var.project, "file", "store", var.environment])
  acl    = "public-read"

	tags = {
		Name = "File Store"
		Project = var.project 
		Environment = var.environment
	}
}


resource "aws_s3_bucket_policy" "filestore" {  
  bucket = aws_s3_bucket.filestore.id   
  policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.filestore.id}/*"            
          ]        
      }    
    ]
}
POLICY
}



resource "aws_s3_bucket_notification" "bucket_notification" {
	bucket = aws_s3_bucket.filestore.id

	topic {
		topic_arn = aws_sns_topic.s3-upload-topic.arn
		events = ["s3:ObjectCreated:*"]
	}
}
