resource "aws_elasticsearch_domain" "server" {
	domain_name = join("-", [var.project, "searchengine", var.environment])
	elasticsearch_version = "7.9"

	ebs_options {
		ebs_enabled = "true"
		volume_size = 10
	}

	cluster_config {
		instance_type = "t3.small.elasticsearch"
	}

	snapshot_options {
		  automated_snapshot_start_hour = 22
	}

	tags = {
		Name = "ES Search Engine"
		Project = var.project
		Environment = var.environment
	}
}

resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.server.domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "${chomp(data.http.myip.body)}/32"}
            },
            "Resource": "${aws_elasticsearch_domain.server.arn}/*"
        },
	{
            "Effect": "Allow",
            "Principal": {
              "AWS": "*"
            },
            "Action": "es:ESHttpGet",
            "Resource": "${aws_elasticsearch_domain.server.arn}/missing/_search"
	}
    ]
}
POLICIES
}


## We want to allow access to the domain for our own IP address specifically.
data "http" "myip" {
    url = "https://ip.seeip.org/"
}
