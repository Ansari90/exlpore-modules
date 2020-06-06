output "asg_name" {
  value = aws_autoscaling_group.terraform_autoscaling_group.name
  description = "Name of the ASG"
}

output "instance_security_group_id" {
  value = aws_security_group.asg_security_group.id
  description = "EC2 Instance Security Group ID"
}