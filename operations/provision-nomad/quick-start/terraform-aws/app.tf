provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  key_name  = "${module.network_aws.ssh_key_name}"
  subnet_id     = "subnet-05c2f0182ed9c2ff4"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = "sg-0ae45a7a13fe4ae4e"
}
