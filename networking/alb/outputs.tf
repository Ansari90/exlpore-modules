output "alb_dns_name" {
  value = aws_lb.terraform_asg_lb.dns_name
  description = "Load Balancer Domain Name"
}

output "alb_http_listener_arn" {
  value = aws_lb_listener.http_listener.arn
  description = "Load Balancer HTTP Listener ARN"
}

output "alb_security_group_id" {
  value = aws_security_group.lb_security_group.id
  description = "ALB Security Group Id"
}