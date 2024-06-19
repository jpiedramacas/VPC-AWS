output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.lab_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.lab_subnet_public1.id, aws_subnet.lab_subnet_public2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.lab_subnet_private1.id, aws_subnet.lab_subnet_private2.id]
}
