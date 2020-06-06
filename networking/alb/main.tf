locals {
  all_ips = ["0.0.0.0/0"]
  any_port = 0
}

resource "aws_security_group" "lb_security_group" {
  name = var.alb_name
}

resource "aws_security_group_rule" "lb_security_group_ingress_rule" {
  type = "ingress"
  security_group_id = aws_security_group.lb_security_group.id

  from_port = var.external_port
  to_port = var.server_port
  protocol = "tcp"
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "lb_security_group_egress_rule" {
  type = "egress"
  security_group_id = aws_security_group.lb_security_group.id

  from_port = local.any_port
  protocol = "-1"
  to_port = local.any_port
  cidr_blocks = local.all_ips
}

resource "aws_lb" "terraform_asg_lb" {
  name = var.alb_name
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.lb_security_group.id]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.terraform_asg_lb.arn
  port = var.external_port
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page Not Found!"
      status_code = 404
    }
  }
}