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


####### Create the EC2 instance ###############

resource "aws_instance" "webserver" {
	ami = "ami-0b5eea76982371e91"
	instance_type = "t2.micro"
}

####### Output the Public DNS of the web server ###############

output "aws_public_dns" {
	value = aws_instance.webserver.public_dns
	
}