variable "environment" {
  description = "Name of the environment being deployed to"
  type = string
}

variable "ami" {
  description = "Amazon Machine Image"
  type = string
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "Type of instance to run"
  type = string
  default = "t2.micro"
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
  default = 8080
}

variable "db_address" {
  description = "Connect to Explore MySQL DB at this endpoint"
  type = string
}

variable "db_port" {
  description = "The port Explore MySQL DB will be listening on"
  type = number
}

variable "custom_tags" {
  description = "Custom Tags to attach to the ASG"
  type = map(string)
}

variable "health_check_type" {
  description = "Health Check type - one of EC2, ELB"
  type = string
  default = "EC2"
}