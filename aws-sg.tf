# security group
resource "aws_security_group" "ha-web" {
  name = "${var.name_prefix}-ha-web"
  description = "Security group for ha-web"
  vpc_id      = "${var.vpc_id}"

  # allow SSH
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # allow http
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # allow https
  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # allow all outgoing tcp traffic
  egress {
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # allow all outgoing udp traffic
  egress {
    protocol = "udp"
    from_port = 0
    to_port = 65535
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
