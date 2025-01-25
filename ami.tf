data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2 AMI naming convention
  }

  owners = ["137112412989"] # Official AWS account for Amazon Linux AMIs
}

output "instance_id" {
  description = "Amazon Linux Image"
  value       = data.aws_ami.amazon_linux.id
}