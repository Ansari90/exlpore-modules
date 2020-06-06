variable "cluster_name" {
  description = "Name prefix for all cluster resources"
  type = string
}

variable "ami" {
  description = "Amazon Machine Image"
  type = string
}

variable "instance_type" {
  description = "Type of instance to run"
  type = string
}

variable "max_size" {
  description = "Max instances to launch"
  type = number
}

variable "min_size" {
  description = "Min instances to launch"
  type = number
}

variable "enable_autoscaling" {
  description = "Allow ASG to increase/decrease servers deployed in response to load"
  type = bool
}

variable "server_port" {
  description = "ASG Port"
  type = number
}

variable "custom_tags" {
  description = "Custom Tags to attach to the ASG"
  type = map(string)
}

variable "subnet_ids" {
  description = "Subnet IDs to deploy to"
  type = list(string)
}

variable "target_group_arns" {
  description = "ARNs of the ELB in which to register Instances"
  type = list(string)
}

variable "health_check_type" {
  description = "Health Check type - one of EC2, ELB"
  type = string
}

variable "user_data" {
  description = "User Data script to run in each instance at boot"
  type = string
  default = null
}