# Cross-repo C2C source-tracing test — NETWORK module.
# Misconfigurations hardcoded HERE (aviactwo). The aviac caller passes the
# name prefix and a DB subnet group it owns.

###############################################################################
# Gateway-001: Transit Gateway 'Auto accept shared attachments' should be off
# Misconfig: auto_accept_shared_attachments = "enable" (no attachments created,
# so this stays near-zero cost).
###############################################################################
resource "aws_ec2_transit_gateway" "gw_001" {
  description                    = "wiz-c2c crossrepo tgw - auto accept enabled (misconfig)"
  auto_accept_shared_attachments = "enable"

  tags = {
    Name    = "${var.name_prefix}-tgw-001"
    Project = "wiz-c2c-crossrepo-test"
  }
}

###############################################################################
# RDS-024: Database instance multi-AZ should be enabled
# Misconfig: multi_az = false. db.t3.micro, single-AZ, destroyed after the test.
###############################################################################
resource "aws_db_instance" "rds_024" {
  identifier           = "${var.name_prefix}-rds-024"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "wizadmin"
  password             = "Wiz-Crossrepo-Test-123!"
  db_subnet_group_name = var.db_subnet_group_name
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true

  tags = { Project = "wiz-c2c-crossrepo-test" }
}

###############################################################################
# RDS-027: RDS Cluster deletion protection should be enabled
# Misconfig: deletion_protection = false. Aurora MySQL cluster created with no
# instances (the cluster entity is what the rule evaluates) to keep cost near
# zero — no instance-hours, only minimal cluster storage.
###############################################################################
resource "aws_rds_cluster" "rds_027" {
  cluster_identifier   = "${var.name_prefix}-rds-027"
  engine               = "aurora-mysql"
  master_username      = "wizadmin"
  master_password      = "Wiz-Crossrepo-Test-123!"
  db_subnet_group_name = var.db_subnet_group_name
  deletion_protection  = false
  skip_final_snapshot  = true

  tags = { Project = "wiz-c2c-crossrepo-test" }
}
