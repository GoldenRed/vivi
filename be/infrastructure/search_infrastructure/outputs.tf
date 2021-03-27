output "es-domain-url" {
	value = aws_elasticsearch_domain.vivi.endpoint
}

output "kibana-url" {
	value = aws_elasticsearch_domain.vivi.kibana_endpoint
}
