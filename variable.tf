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