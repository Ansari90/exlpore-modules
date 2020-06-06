variable "db_password" {
  description = "MySQL Stage admin password"
  type = string
}

variable "instance_type" {
  description = "Type of instance to run"
  type = string
}

variable "allocated_storage" {
  description = "Amount of storage to provide to the DB"
  type = number
  default = 10
}

variable "engine" {
  description = "Database Engine to use"
  type = string
  default = "mysql"
}

variable "cluster_name" {
  description = "Name prefix for all cluster resources"
  type = string
}