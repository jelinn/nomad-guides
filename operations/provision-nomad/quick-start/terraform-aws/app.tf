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

resource "aws_instance" "client1" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name             = "jlinn-dev-useast2"
  subnet_id            = "subnet-0dbfc8b50e2e3f44e"
  tags = {
    Name = "jlinn-nomad-demo-consul-node"
  }
}
resource "aws_instance" "client2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name             = "jlinn-dev-useast2"
  subnet_id            = "subnet-0dbfc8b50e2e3f44e"
  tags = {
    Name = "jlinn-nomad-demo-consul-node"
  }
}
output "client1_ip_addr" {
  value = "${aws_instance.client1.private_ip}"
}
output "client2_ip_addr" {
  value = "${aws_instance.client2.private_ip}"
}

