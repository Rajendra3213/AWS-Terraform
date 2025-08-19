resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = merge(var.tags, {
    Name = "${var.nat_name}-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id
  
  tags = merge(var.tags, {
    Name = var.nat_name
  })
}