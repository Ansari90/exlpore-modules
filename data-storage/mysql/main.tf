resource "aws_db_instance" "exploreDB" {
  identifier_prefix = "${var.cluster_name}-terraform-db"
  engine = var.engine
  allocated_storage = var.allocated_storage
  instance_class = var.instance_type
  name = "${var.cluster_name}ExploreDB"
  username = "admin"

  password = var.db_password
}