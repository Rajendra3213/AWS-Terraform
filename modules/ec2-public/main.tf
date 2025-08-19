resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.root}/${var.key_name}.pem"
  file_permission = "0400"
}

resource "aws_instance" "public" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  
  tags = merge(var.tags, {
    Name = var.instance_name
  })
}