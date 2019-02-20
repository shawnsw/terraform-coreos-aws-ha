# create a jumpbox for managing instances
resource "aws_instance" "jumpbox" {
  ami                         = "${data.aws_ami.coreos_stable_latest.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.ssh.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.ha-web.id}"]
  subnet_id                   = "${var.subnet_a}"
  associate_public_ip_address = true

  tags {
    Name = "jumpbox"
  }
}