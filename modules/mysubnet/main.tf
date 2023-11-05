# create default gateway to attached it to vpc
resource "aws_internet_gateway" "elkholy-gw" {
  vpc_id = var.vpc-id
  tags = {
    Name = "${var.env}-gw"
  }
}
# create default-route-table
resource "aws_default_route_table" "elkholy-table" {
  default_route_table_id = var.vpc-default-route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elkholy-gw.id
  }
  tags = {
    Name = "${var.env}-route"
  }
}
# create subnet
resource "aws_subnet" "elkholy-subnet" {
  vpc_id = var.vpc-id
  cidr_block = var.subnet-cidr
  tags = {
    Name = "${var.env}-subnet"
  }
}
# we don't need to atached route table to subnet, as we edit in default vpc route tabe
# that attached to all subnets by default