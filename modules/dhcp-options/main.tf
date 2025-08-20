resource "aws_vpc_dhcp_options" "main" {
  domain_name = var.domain_name
  
  tags = var.tags
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}