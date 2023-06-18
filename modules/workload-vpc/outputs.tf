output "workload_vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.my-vpc.id
}


output "private_subnet_ids" {
  value = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}

output "db_subnet_ids" {
  value = [aws_subnet.db-subnet-1.id, aws_subnet.db-subnet-2.id]
}
