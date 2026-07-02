resource "aws_key_pair" "my_key" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))
}