provider "aws" {
  region = "eu-west-1"
  profile = "terraform"
}

# craete vpc
resource "aws_vpc" "elkholy-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

# call subnet module
module "elkholy-subnet" {
  source = "./modules/mysubnet"
  env = var.env
  vpc-id = aws_vpc.elkholy-vpc.id
  vpc-default-route = aws_vpc.elkholy-vpc.default_route_table_id
  subnet-cidr = var.subnet-cidr
}

# call instance module
module "elkholy-instance" {
  source = "./modules/myapp"
  env = var.env
  vpc-id = aws_vpc.elkholy-vpc.id
  ingress-cidr = var.ingress-cidr
  subnet-id = module.elkholy-subnet.mysubnet.id
  instance-type = var.instance-type
  ssh-pub = var.ssh-pub
}