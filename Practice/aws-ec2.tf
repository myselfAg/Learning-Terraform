resource "aws_instance" "webserver" {
  ami = ami-id
  instance_type = "t2.micro"
}