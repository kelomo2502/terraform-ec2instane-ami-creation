# terraform-ec2instane-ami-creation

## Purpose

In this mini project, you will use Terraform to automate the launch of an EC2 instance on AWS. The project includes the generation of a downloadable key pair for the instance and the execution of a user data script to install and configure Apache HTTP server.

## Objectives

1. Terraform Configuration
   Learn how to write Terraform code to launch an EC2 instance with specified configurations.
2. Keypair generation
   Generate a key pair and make it downloadable after EC2 instance creation.
   This will be achieved by using the terraform aws tls_private_key resoure

```DSL
   resource "tls_private_key" "key_pair" {

  algorithm = "RSA"
  rsa_bits  = 2048
}

### Create the key pair in AWS

resource "aws_key_pair" "gb_key" {
  key_name   = "gb_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}

### Save the private key to a local file

resource "local_file" "private_key" {
  filename = "gb_key.pem"
  content  = tls_private_key.key_pair.private_key_pem

### Set secure permissions (optional but recommended)

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

   ```

3. User Data execution
We can excute user data at instance lunch by using the terraform aws_instance resources and its ancillary user_data argument as follows:

```DSL
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

```

4. Save the file
5. Run `terraform init`
6. Run `terraform apply` to apply the configuration
We can access the apache server using the launched ec2 instance IP address
