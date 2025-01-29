resource "aws_key_pair" "gb_key" {
  key_name   = "gb_key"
  public_key = var.public_key
}