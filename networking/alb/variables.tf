variable "alb_name" {
  description = "ALB Name"
  type = string
}

variable "server_port" {
  description = "Port on ASG to connect load balancer tp"
  type = number
  default = 8080
}

variable "external_port" {
  description = "Port to receive external requests on"
  type = number
  default = 80
}

variable "subnet_ids" {
  description = "Subnet IDs to deploy to"
  type = list(string)
}