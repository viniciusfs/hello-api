region = "us-east-1"
environment = "staging"

vpc_id = "vpc-d34451a8"
subnets = ["subnet-0515df59", "subnet-767e9948"]
domain_zone_id = "ZT99DT4VMP2W8"

name = "hello-api"
container_port = "5000"

desired_count = 1
alb_listener_rule_priority = 99

image_name = "devops/hello-api"
image_tag = "latest"

container_memory = 256
container_cpu = 256

repository_url = "327667905059.dkr.ecr.us-east-1.amazonaws.com"
