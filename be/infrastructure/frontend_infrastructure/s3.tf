resource "aws_s3_bucket" "frontend" {
  bucket_prefix = join("-", [var.project, "frontend", "bucket"])
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
	Name = "Frontend Bucket",
	Project = var.project,
	Environment = var.environment
	}
}


resource "aws_s3_bucket_policy" "frontend" {  
  bucket = aws_s3_bucket.frontend.id   
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
             "arn:aws:s3:::${aws_s3_bucket.frontend.id}/*"            
          ]        
      }    
    ]
}
POLICY
}

## Upload files to S3
resource "null_resource" "upload_to_s3" {
	provisioner "local-exec" {
		command = "aws s3 sync ${path.module}/source s3://${aws_s3_bucket.frontend.id}"
  	}
}


