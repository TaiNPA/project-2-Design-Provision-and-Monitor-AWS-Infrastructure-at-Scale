# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "<Your Access Key>"
  secret_key = "<Your Secret Key>"
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  count = "4"
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  tags = {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# Comment code to destroy
# resource "aws_instance" "Udacity_M4" {
#   count = "2"
#   ami = "ami-053b0d53c279acc90"
#   instance_type = "m4.large"
#   tags = {
#    Name = "Udacity M4"
#  }
# }