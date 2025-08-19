resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  
  tags = merge(var.tags, {
    Name = var.subnet_name
  })
}

resource "aws_route_table" "subnet_rt" {
  vpc_id = var.vpc_id
  
  tags = merge(var.tags, {
    Name = "${var.subnet_name}-rt"
  })
}

resource "aws_route_table_association" "subnet_rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.subnet_rt.id
}