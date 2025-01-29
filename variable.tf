variable "region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_instance_name" {
  type    = string
  default = "Dev_Server"
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "public_key" {
  type = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG47BFg3apIX7SbRuDhzsDAd5GuzwkdKccYN74SFT7EH Gbenga@Gbenga"
}