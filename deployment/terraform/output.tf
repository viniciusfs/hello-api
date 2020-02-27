output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.hello_api.arn
}

output "ecs_service_arn" {
  value = aws_ecs_service.hello_api.id
}

output "ecs_service_name" {
  value = aws_ecs_service.hello_api.name
}

output "ecs_service_cluster" {
  value = aws_ecs_service.hello_api.cluster
}

output "ecs_service_desired_count" {
  value = aws_ecs_service.hello_api.desired_count
}

output "route53_fqnd" {
  value = aws_route53_record.hello_api.fqdn
}
