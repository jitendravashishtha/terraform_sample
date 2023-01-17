####### Declare variables ###############
variable "aws_access_key" {}
variable "aws_secret_key" {}

####### declare region
variable "aws_region"{
	default = "us-east-1"
} 

####### Define the provider 
provider "aws" {
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
	region = var.aws_region
}

###############data source##########
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

####### Create the EC2 instance ###############
resource "aws_instance" "webserver" {
	ami = data.aws_ami.aws-linux.id
	instance_type = "t2.micro"
}

####### Output the Public DNS of the web server ###############
output "aws_public_dns" {
	value = aws_instance.webserver.public_dns
	
}