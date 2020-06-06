resource "aws_security_group" "asg_security_group" {
  name = "${var.cluster_name}-asg-security-group"
}

resource "aws_security_group_rule" "asg_security_group_ingress_rule" {
  type = "ingress"
  security_group_id = aws_security_group.asg_security_group.id

  from_port = var.server_port
  to_port = var.server_port
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_launch_configuration" "terraform_server_launch_config" {
  image_id = var.ami
  security_groups = [aws_security_group.asg_security_group.id]
  instance_type = var.instance_type
  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform_autoscaling_group" {
  launch_configuration = aws_launch_configuration.terraform_server_launch_config.name
  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [var.target_group_arns]
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags:
      key => upper(value)
      if key != "Name"
    }

    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "scale_out_during_business_hours"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.max_size
  recurrence = "0 9 * * *"

  autoscaling_group_name = aws_autoscaling_group.terraform_autoscaling_group.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name = "scale_in_at_night"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.min_size
  recurrence = "0 17 * * *"

  autoscaling_group_name = aws_autoscaling_group.terraform_autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name = "${var.cluster_name}-low-cpu-credit-balance"
  namespace = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.terraform_autoscaling_group.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods = 1
  period = 300
  statistic = "Minimum"
  threshold = 10
  unit = "Count"
}