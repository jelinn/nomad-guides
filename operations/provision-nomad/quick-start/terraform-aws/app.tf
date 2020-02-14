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
  key_name             = "${var.ssh_key_name != "" ? var.ssh_key_name : module.ssh_keypair_aws.name}"
  subnet_id            = "${element(aws_subnet.public.*.id, count.index)}"
  tags = {
    Name = "jlinn-nomad-demo-consul-node"
  }
}
resource "aws_instance" "client2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name             = "${var.ssh_key_name != "" ? var.ssh_key_name : module.ssh_keypair_aws.name}"
  subnet_id            = "${element(aws_subnet.public.*.id, count.index)}"
  tags = {
    Name = "jlinn-nomad-demo-consul-node"
  }
}
output "client1_ip_addr" {
  value = aws_instance.server.public_ip
}
output "client2_ip_addr" {
  value = aws_instance.client2.public_ip
}

