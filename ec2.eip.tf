resource "aws_eip" "this" {
  domain = "vpc"

  tags = { Name = "${var.vpc.name}-${var.vpc.nat_gateway_eip_name}" }
}
