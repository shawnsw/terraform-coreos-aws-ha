# create alb
resource "aws_lb" "ha-web" {
  name               = "${var.name_prefix}-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.ha-web.id}"]
  subnets            = ["${var.subnet_a}", "${var.subnet_b}", "${var.subnet_c}"]

  enable_deletion_protection = true

  tags = {
    Name = "${var.name_prefix}"
  }
}

# create target group
resource "aws_lb_target_group" "ha-web" {
  name     = "${var.name_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

# create https listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.ha-web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.certificate.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.ha-web.arn}"
  }
}

# create http listener that fowards to https
resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.ha-web.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
