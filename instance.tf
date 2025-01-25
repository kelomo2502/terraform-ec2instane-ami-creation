resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.gb_key.key_name
  vpc_security_group_ids = [aws_security_group.gb_sg.id]
  availability_zone      = var.availability_zone
  count                  = var.number_of_instances

  tags = {
    Name = var.ec2_instance_name
  }



  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF


}

output "instance_public_ip_addr" {
  value = [for instance in aws_instance.web : instance.public_ip]
}
