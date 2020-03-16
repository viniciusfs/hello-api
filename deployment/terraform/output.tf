output "ecs_service_arn" {
  value = module.ecs_service.ecs_service_arn
}

output "ecs_service_name" {
  value = module.ecs_service.ecs_service_name
}

output "ecs_service_cluster" {
  value = module.ecs_service.ecs_service_cluster
}

output "ecs_task_definition_arn" {
  value = module.ecs_service.ecs_task_definition_arn
}

output "ecs_task_definition_family" {
  value = module.ecs_service.ecs_task_definition_family
}

output "ecs_task_definition_revision" {
  value = module.ecs_service.ecs_task_definition_revision
}

output "application_fqdn" {
  value = module.ecs_service.route53_fqdn
}
