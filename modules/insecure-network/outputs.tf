output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.gw_001.id
}

output "rds_instance_id" {
  value = aws_db_instance.rds_024.id
}

output "rds_cluster_id" {
  value = aws_rds_cluster.rds_027.id
}
