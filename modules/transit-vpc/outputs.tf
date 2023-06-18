output "transit_vpc_id" {
  value = aws_vpc.transit-vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.transit-public-1a.id, aws_subnet.transit-public-1b.id]
}

output "public_subnet_cidr_blocks" {
  value = [aws_subnet.transit-public-1a.cidr_block, aws_subnet.transit-public-1b.cidr_block]
}

output "public_route_table_id" {
  value = aws_route_table.transitvpc-public-rt.id
}

output "security_group_id" {
  value = aws_security_group.transit-vpc-web_security_group.id
}
