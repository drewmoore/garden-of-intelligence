# ---------------------------------------------------------------------------------------------------------------------
# NETWORK DETAILS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "172.17.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.APP_NAME}-VPC"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count             = length(data.aws_availability_zones.available.names)
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "${var.APP_NAME}-PrivateSubnet-${count.index + 1}"
  }
}
