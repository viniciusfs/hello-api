resource "aws_ecs_task_definition" "hello_api" {
  family                = "hello-api"
  container_definitions = file("hello-api.json")
  network_mode          = "awsvpc"
}

resource "aws_ecs_service" "hello_api" {
  name            = "hello-api"
  cluster         = data.terraform_remote_state.cluster.outputs.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.hello_api.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_api.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.hello_api.id]
  }
}

resource "aws_security_group" "hello_api" {
  name        = "hello-api"
  description = "Allow inbound/outbound traffic for Hello API intances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hello-api"
  }
}

resource "aws_appautoscaling_target" "hello_api" {
  max_capacity       = 4
  min_capacity       = 0
  resource_id        = "service/${data.terraform_remote_state.cluster.outputs.ecs_cluster_name}/${aws_ecs_service.hello_api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_lb_target_group" "hello_api" {
  name        = "hello-api-${var.environment}"
  protocol    = "HTTP"
  port        = 5000
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener_rule" "hello_api" {
  listener_arn = data.terraform_remote_state.cluster.outputs.alb_listener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hello_api.arn
  }

  condition {
    host_header {
      values = ["hello-api.zoop.tech", "hello-api.*.zoop.tech"]
    }
  }
}

resource "aws_route53_record" "hello_api" {
  zone_id = var.domain_zone_id
  name    = var.environment == "production" ? "hello-api" : "hello-api.${var.environment}"
  type    = "A"
  alias {
    name                   = data.terraform_remote_state.cluster.outputs.alb_dns_name
    zone_id                = data.terraform_remote_state.cluster.outputs.alb_zone_id
    evaluate_target_health = true
  }
}
