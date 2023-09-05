locals {
  availability_zones_names = slice(data.aws_availability_zones.available.names, 0, max(var.public_subnet_count, var.private_subnet_count, length(var.public_subnet_cidrs), length(var.private_subnet_cidrs)))
  availability_zones_ids   = slice(data.aws_availability_zones.available.zone_ids, 0, max(var.public_subnet_count, var.private_subnet_count, length(var.public_subnet_cidrs), length(var.private_subnet_cidrs)))

  #  vpc_name         = "${var.environment}-${var.account_name}-${var.vpc_name}-VPC"
  public_subnets   = length(var.public_subnet_cidrs) != 0 ? var.public_subnet_cidrs : [for index in range(var.public_subnet_count) : cidrsubnet(var.vpc_cidr, 8, index + var.public_subnet_network_start)]
  private_subnets  = length(var.private_subnet_cidrs) != 0 ? var.private_subnet_cidrs : [for index in range(var.private_subnet_count) : cidrsubnet(var.vpc_cidr, 4, index + 1)]
  # database_subnets = length(var.database_subnet_cidrs) != 0 ? var.database_subnet_cidrs : [for index in range(var.database_subnet_count) : cidrsubnet(var.vpc_cidr, 8, index + var.database_subnet_network_start)]
  # tgw_subnets      = length(var.tgw_subnet_cidrs) != 0 ? var.tgw_subnet_cidrs : [for index in range(var.tgw_subnet_count) : cidrsubnet(var.vpc_cidr, 12, index + var.tgw_subnet_network_start)]
}

data "aws_availability_zones" "available" {
  state = "available"
}

#####################################################
# Create VPC
#####################################################

module "vpc" {
  # we use local module because we need RT per AZ for Inspection VPC (for direct traffic to specific FW Endpoint per AZ)
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                  = local.availability_zones_names
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  public_subnets          = local.public_subnets
  public_subnet_suffix    = var.public_subnet_suffix
  public_subnet_names     = [for az_name in local.availability_zones_names : "${var.vpc_name}-${var.public_subnet_suffix}-${az_name}-subnet"]
  public_subnet_tags      = var.public_subnet_tags
  public_route_table_tags = var.public_route_table_tags

  private_subnets          = local.private_subnets
  private_subnet_suffix    = var.private_subnet_suffix
  private_subnet_names     = [for az_name in local.availability_zones_names : "${var.vpc_name}-${var.private_subnet_suffix}-${az_name}-subnet"]
  private_subnet_tags      = var.private_subnet_tags
  private_route_table_tags = var.private_route_table_tags

  # database_subnets             = local.database_subnets
  # database_subnet_suffix       = var.database_subnet_suffix
  # database_subnet_names        = [for az_name in local.availability_zones_names : "${var.vpc_name}-${var.database_subnet_suffix}-${az_name}-subnet"]
  # database_subnet_tags         = var.database_subnet_tags
  # create_database_subnet_group = var.create_database_subnet_group

  # intra_subnets          = local.tgw_subnets
  # intra_subnet_suffix    = var.tgw_subnet_suffix
  # intra_subnet_names     = [for az_name in local.availability_zones_names : "${var.vpc_name}-${var.tgw_subnet_suffix}-${az_name}-subnet"]
  # intra_subnet_tags      = var.tgw_subnet_tags
  # intra_route_table_tags = var.tgw_route_table_tags

  #VPC Flow Logs
  enable_flow_log                   = var.enable_flow_log
  flow_log_traffic_type             = var.flow_log_traffic_type
  flow_log_destination_type         = var.flow_log_destination_type
  flow_log_log_format               = var.flow_log_log_format
  flow_log_destination_arn          = var.flow_log_destination_arn # "${var.flow_log_destination_arn}/${var.vpc_name}/"
  flow_log_max_aggregation_interval = var.flow_log_max_aggregation_interval

  tags = var.vpc_tags
}
