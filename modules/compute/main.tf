data "aws_subnet" "selected" { id = var.subnet_id }
resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = "Restrictive security group for ${var.name}"
  vpc_id = data.aws_subnet.selected.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_ingress_cidrs
    content {
      description = "Explicitly configured HTTPS ingress"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  egress {
    description = "Outbound IPv4"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.name}-sg" })
}
resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  associate_public_ip_address = false
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 1
  }
  root_block_device {
    encrypted = true
    volume_type = "gp3"
  }
  tags = merge(var.tags, { Name = var.name })
}