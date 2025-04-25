Terraform EC2 Instance & AMI Creation
Purpose
This project demonstrates the use of Terraform to automate the launch of an EC2 instance on AWS, including key pair generation and the execution of a user data script to install and configure Apache HTTP server.

Objectives
Terraform Configuration: Write Terraform code to launch an EC2 instance.
Keypair Generation: Generate a key pair using aws tls_private_key.
User Data Execution: Execute user data to install Apache HTTP server.
Getting Started
Prerequisites
Terraform installed
AWS account with proper permissions
AWS CLI configured
Files Overview
main.tf: Terraform configuration for EC2 instance, key pair, and user data.
variables.tf: Variables for instance type, availability zone, etc.
Code Snippets
Key Pair Generation
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "gb_key" {
  key_name   = "gb_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "gb_key.pem"
  content  = tls_private_key.key_pair.private_key_pem

  provisioner "local-exec" {
    command = "chmod 400 gb_key.pem"
  }
}

resource "local_file" "public_key" {
  filename = "gb_key.pem"
  content  = tls_private_key.key_pair.public_key_pem

  provisioner "local-exec" {
    command = "chmod 400 gb_key.pem"
  }
}

EC2 Instance with Apache HTTP Setup
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

Steps to Deploy
Clone the repository.

Run terraform init to initialize the Terraform configuration.

Apply the configuration with terraform apply.

Access the Apache HTTP server using the EC2 instance's public IP.

Conclusion
This project demonstrates the automation of launching EC2 instances with Terraform, including key pair management and configuring Apache HTTP server using a user data script.
