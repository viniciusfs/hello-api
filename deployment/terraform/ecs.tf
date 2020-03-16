module "label" {
 source = "../../../tf-module-label/"

 application = "hello-api"
 service = "testing"
 environment = var.environment
 business_owner = "infra"
 namespace = "ecs"

 tags = {
    shutdown       = "true"
    shutdown_hour  = "19:00"
    wakeup_hour    = "10:00"
  }
}

module "ecs_service" {
  source = "../../../tf-module-ecs-application/"

  name = module.label.id

  ecs_cluster_arn = data.terraform_remote_state.cluster.outputs.ecs_cluster_arn
  vpc_id = var.vpc_id
  subnets = var.subnets

  container_definitions = data.template_file.container_definitions.rendered
  container_port = var.container_port
  desired_count = var.desired_count

  alb_listener_arn = data.terraform_remote_state.cluster.outputs.alb_listener_arn
  alb_listener_rule_priority = var.alb_listener_rule_priority

  alb_dns_name = data.terraform_remote_state.cluster.outputs.alb_dns_name
  alb_zone_id = data.terraform_remote_state.cluster.outputs.alb_zone_id
  domain_zone_id = var.domain_zone_id
  domain_name = module.label.domain_name

  tags = module.label.tags
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/container-definitions.json")}"

  vars = {
    name = module.label.id
    environment = var.environment
    container_port = var.container_port
    container_memory = var.container_memory
    container_cpu = var.container_cpu
    image_name = var.image_name
    image_tag = var.image_tag
    repository_url = var.repository_url
  }
}
