# launch profile
resource "aws_launch_configuration" "ha-web" {
  name_prefix = "${var.name_prefix}-"
  image_id = "${data.aws_ami.coreos_stable_latest.id}"
  instance_type = "${var.instance_type}"
  security_groups = [
    "${aws_security_group.ha-web.id}"]
  user_data = "${data.ignition_config.ha-web.rendered}"
  key_name = "${aws_key_pair.ssh.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ha-web.id}"
  associate_public_ip_address = false
  lifecycle = {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ha-web" {
  name = "${var.name_prefix}"
  max_size = 3
  min_size = 2
  desired_capacity = 2
  health_check_grace_period = 120
  health_check_type = "ELB"
  force_delete = true
  suspended_processes = []
  termination_policies = [
    "OldestInstance"]
  vpc_zone_identifier  = ["${var.subnet_a}", "${var.subnet_b}", "${var.subnet_c}"]
  launch_configuration = "${aws_launch_configuration.ha-web.name}"

  tags = [
    {
      key = "Name"
      value = "${var.name_prefix}"
      propagate_at_launch = true
    },
    {
      key = "Purpose"
      value = "web"
      propagate_at_launch = true
    }]

  timeouts {
    delete = "15m"
  }
}

# ASG attachment
resource "aws_autoscaling_attachment" "ha-web" {
  autoscaling_group_name = "${aws_autoscaling_group.ha-web.name}"
  alb_target_group_arn = "${aws_lb_target_group.ha-web.arn}"
}
