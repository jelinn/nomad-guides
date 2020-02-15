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

resource "aws_security_group" "testenv_allow_all_DO_NOT_PROD" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}


resource "aws_instance" "client1" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name             = "jlinn-dev-useast2"
  vpc_security_group_ids = [${aws_security_group.testenv_allow_all_DO_NOT_PROD.id}]
  user_data = <<-EOT
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y unzip python3 python3-pip
    wget https://releases.hashicorp.com/consul/1.7.0/consul_1.7.0_linux_amd64.zip
		unzip consul_1.7.0_linux_amd64.zip
    mkdir /etc/consul
  EOT
	
  tags = {
    Name = "jlinn-nomad-demo-consul-node"
  }
}

resource "aws_instance" "client2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  key_name             = "jlinn-dev-useast2"
  vpc_security_group_ids = [${aws_security_group.testenv_allow_all_DO_NOT_PROD.id}]

  user_data = <<-EOT
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y unzip python3 python3-pip
    wget https://releases.hashicorp.com/consul/1.7.0/consul_1.7.0_linux_amd64.zip
		unzip consul_1.7.0_linux_amd64.zip
    mkdir /etc/consul
  EOT
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

