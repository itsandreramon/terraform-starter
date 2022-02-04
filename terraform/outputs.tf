output "db_address" {
  value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "instance_dns" {
  value = aws_instance.instance.public_dns
}
