resource "aws_ec2_instance_state" "web_state" {
  count       = length(aws_instance.web)
  instance_id = aws_instance.web[count.index].id
  state       = "running"
}
