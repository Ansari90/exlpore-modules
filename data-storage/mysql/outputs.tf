output "address" {
  value = aws_db_instance.exploreDB.address
  description = "Connect to Explore MySQL DB at this endpoint"
}

output "port" {
  value = aws_db_instance.exploreDB.port
  description = "The port Explore MySQL DB will be listening on"
}