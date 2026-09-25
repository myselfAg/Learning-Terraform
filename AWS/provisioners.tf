# remote-exec
resource "aws_instance" "webserver" {
  ami = "amiID"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
    Description = "An Nginx WebServer on Ubuntu"
  }
  
  provisioner "remote-exec" {
    inline = [ 
        "sudo apt update",
        "sudo apt install nginx -y",
        "systemctl enable nginx",
        "systemctl start nginx"
     ]
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/root/.ssh/web")
  }
  key_name = aws_key_pair.web.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
}


# local-exec
resource "aws_instance" "webserver" {
  ami = "amiID"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
    Description = "An Nginx WebServer on Ubuntu"
  }
  # this will run after the instance is created
  provisioner "local-exec" {
    command = "echo ${aws_instance.webserver.public_ip} >> /tmp/ips.txt"
  }

  # this will run after the instance is created
  provisioner "local-exec" {
    when = destroy
    command = "echo ${aws_instance.webserver.public_ip} >> /tmp/ips.txt"
  }

  # if something fails while provisioning the apply command will be done without the provisioning command
  provisioner "local-exec" {
    on_failure = continue
    command = "echo ${aws_instance.webserver.public_ip} >> /tomp/ips.txt"
  }

  # if something fails while provisioning the apply command will be failed
  provisioner "local-exec" {
    on_failure = fail
    command = "echo ${aws_instance.webserver.public_ip} >> /tomp/ips.txt"
  }

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