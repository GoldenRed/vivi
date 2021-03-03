module "api" {
	source = "./api_infrastructure"
}

module "es" {
	source = "./search_infrastructure"
}

module "filestore" {
	source = "./filestore_infrastructure"
}



output "api_alpha_url" {
	value = module.api.api_alpha_stage_url
}
output "direct-es-domain-url" {
	value = module.es.es-domain-url
}
output "kibana-url" {
	value = module.es.kibana-url
}
