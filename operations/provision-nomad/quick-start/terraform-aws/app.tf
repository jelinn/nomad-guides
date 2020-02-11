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
  name          = "${var.name}"
  key_name  = "${module.network_aws.ssh_key_name}"
  subnet_ids     = "${module.network_aws.subnet_private_ids}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
}
