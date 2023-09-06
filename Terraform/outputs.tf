output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR Block of the VPC"
  value       = var.vpc_cidr
}

output "name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "tgw_subnets" {
  description = "List of IDs of Transit Gateway Attachment subnets"
  value       = module.vpc.intra_subnets
}

output "tgw_route_table_ids" {
  description = "List of IDs of Transit Gateway Attachment route tables"
  value       = module.vpc.intra_route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of Private route tables"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "List of IDs of Private route tables"
  value       = module.vpc.public_route_table_ids
}