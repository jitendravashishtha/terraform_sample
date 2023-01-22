####### Declare variables ###############
variable "aws_access_key" {}
variable "aws_secret_key" {}

####### declare region
variable "aws_region"{
	default = "us-east-1"
} 

variable "network_address_space" {
	default = "10.0.0.0/16"
}

variable "subnet_address_space" {
  default = "10.0.1.0/24"
}

####### Define the provider 
provider "aws" {
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
	region = var.aws_region
}

###############data source for ami##########
data "aws_ami" "aws-linux"{
	most_recent = true
	owners = ["amazon"]
	filter {
	  name = "name"
	  values = ["amzn2-ami-hvm*"]
	}
	filter {
	  name = "root-device-type"
	  values = ["ebs"]
	}
	filter {
	  name = "virtualization-type"
	  values = [ "hvm" ]
	}
}

###############data source availability zone###
data "aws_availability_zones" "available" {}

######## ADD VPC to the hosting server ########
resource "aws_vpc" "vpc" {
  cidr_block = var.network_address_space
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "mysubnet" {
  cidr_block = var.subnet_address_space
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
	  cidr_block = "0.0.0.0/0"
	  gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "allow_traffic" {
	name = "MywebServer"
	description = "My Webserver description"
	vpc_id = aws_vpc.vpc.id
	ingress = [{
	  cidr_blocks = [ "0.0.0.0/0" ]
	  description = "ingress"
	  from_port = 80
	  to_port = 80
	  protocol = "tcp"
	  ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
	} ]
	egress = [{
	  cidr_blocks = [ "0.0.0.0/0" ]
	  description = "egress"
	  protocol = -1
	  from_port = 0
	  to_port = 0
	  ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false

	} ]
}

####### Create the EC2 instance ###############
resource "aws_instance" "webserver" {
	ami = data.aws_ami.aws-linux.id
	instance_type = "t2.micro"
	subnet_id = aws_subnet.mysubnet.id
	vpc_security_group_ids = [aws_security_group.allow_traffic.id]
	user_data = file("install_apache.sh")
}

####### Output the Public DNS of the web server ###############
output "aws_public_dns" {
	value = aws_instance.webserver.public_dns	
}