output "id" {
  value = aws_vpc.vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.subnet_group_db.name
}

output "instance_subnet_id" {
  value = aws_subnet.subnet_instance.id
}
