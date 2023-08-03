# ---------------------------------------------------------------------------------------------------------------------
# RDS DB SUBNET GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "${var.APP_NAME}-db-sgrp"
  description = "Database Subnet Group"
  subnet_ids  = aws_subnet.private.*.id
}

# ---------------------------------------------------------------------------------------------------------------------
# RDS (POSTGRESQL)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_db_instance" "db" {
  identifier = var.APP_NAME

  engine         = "postgres"
  engine_version = "13.10"

  instance_class = "db.t3.micro"

  storage_type      = "gp2"
  allocated_storage = 20

  username = "root"
  # TODO: generate and hide
  password = "05cd8d797da4fb88a199c14294b5966fe9276e7c61c5476116addcf44facab4aa77a12541050c25312f3fd20f839cea4b2cdb1b42bfade1dd612027f6a1d4a01"

  multi_az = false
  vpc_security_group_ids  = [aws_security_group.db-sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-grp.id
}

output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}
