# define security group
resource "aws_security_group" "elkholy-sq" {
    name = "allow connection"
    description = "allow for incomming ssh connection and allow all outcoming conniction"
    vpc_id = var.vpc-id
    ingress {
        description = "allow for ssh connection"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ var.ingress-cidr ]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.env}-sg"
    }
}
# get ami for linux 2023
data "aws_ami" "linux2023" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
        name = "name"
        values = [ "al2023-ami-2023*" ]
    }
    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
}
# create key pair for aws instance
resource "aws_key_pair" "elkholy-keypair" {
    key_name = "iti_terraform_${var.env}"
    public_key = file(var.ssh-pub)
}
# create instance
resource "aws_instance" "linux2023" {
    ami = data.aws_ami.linux2023.id
    instance_type = var.instance-type
    subnet_id = var.subnet-id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.elkholy-sq.id]    
    key_name = aws_key_pair.elkholy-keypair.key_name
    tags = {
        Name = "${var.env}-linux2023"
    }
}