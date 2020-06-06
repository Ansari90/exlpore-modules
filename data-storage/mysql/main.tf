resource "aws_db_instance" "exploreDB" {
  identifier_prefix = "${var.cluster_name}-terraform-db"
  engine = var.engine
  allocated_storage = var.allocated_storage
  instance_class = var.instance_type
  name = "${var.cluster_name}ExploreDB"
  username = "admin"
  skip_final_snapshot = true

  password = var.db_password
}