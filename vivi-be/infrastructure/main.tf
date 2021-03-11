
module "api" {
	source = "./api_infrastructure"

	environment = var.environment
	region = var.region
	project = var.project

	upload_bucket = module.filestore.limbo-bucket
	es_url = module.es.es-domain-url

}

module "es" {
	source = "./search_infrastructure"

	environment = var.environment
	region = var.region
	project = var.project
}


module "filestore" {
	source = "./filestore_infrastructure"

	environment = var.environment
	region = var.region
	project = var.project

	es_url = module.es.es-domain-url
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
