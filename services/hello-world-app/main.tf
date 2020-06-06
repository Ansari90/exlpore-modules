data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "exploreDB" {
  backend = "s3"

  config = {
    bucket = "a3-explore-terraform-state"
    key = var.db_remote_state_bucket_key
    region = "us-east-2"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    db_address = data.terraform_remote_state.exploreDB.outputs.address
    db_port = data.terraform_remote_state.exploreDB.outputs.port
  }
}

module "alb" {
  source = "../../networking/alb"

  alb_name = "hello-world-${var.environment}"
  subnet_ids = data.aws_subnet_ids.default.ids
}

resource "aws_alb_target_group" "terraform_lb_tg" {
  name = "${var.environment}-terraform-lb-target-group"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "http_listener_rule" {
  listener_arn = module.alb.alb_http_listener_arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  # Old way mentioned in book, chapter 2 - pg 69
  # condition {
  #   field = "path-pattern"
  #   values = ["*"]
  # }

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.terraform_lb_tg.arn
  }
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name = "hello-world-${var.environment}"
  ami = var.ami
  user_data = data.template_file.user_data.rendered
  instance_type = var.instance_type
  server_port = var.server_port

  min_size = var.min_size
  max_size = var.max_size
  enable_autoscaling = var.enable_autoscaling

  subnet_ids = data.aws_subnet_ids.default.ids
  target_group_arns = [aws_alb_target_group.terraform_lb_tg.arn]
  health_check_type = var.health_check_type

  custom_tags = var.custom_tags
}