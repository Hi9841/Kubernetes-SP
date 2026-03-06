output "security_group_id" {
  value = aws_security_group.allow_http_ssh.id
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}