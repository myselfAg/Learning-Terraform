resource "aws_instance" "webserver" {
  ami = "amiID"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
    Description = "An Nginx WebServer on Ubuntu"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    systemctl enable nginx
    systemctl start nginx
  EOF

  key_name = aws_key_pair.web.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
}

resource "aws_key_pair" "web" {
  public_key = file("/root/.ssh/web.pub")
#   public_key = "<public_key>"
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "Allow SSH access from the internet"
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "publicip" {
  value = aws_instance.webserver.public_ip
}

# Provider.tf
provider "aws" {
  region = "ap-south-1"
}