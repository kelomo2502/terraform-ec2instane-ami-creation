resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.gb_key.key_name
  vpc_security_group_ids = [aws_security_group.gb_sg.id]
  availability_zone      = var.availability_zone

  tags = {
    Name = "kelomoServer"
  }
}

output "instance_public_ip_addr" {
  value = aws_instance.web.public_ip
}

