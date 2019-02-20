# create ha-web IAM role
resource "aws_iam_role" "ha-web" {
  name = "${var.name_prefix}-ha-web"
  description = "Default ha-web role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# create IAM policy
resource "aws_iam_policy" "ha-web" {
  name = "${var.name_prefix}-default-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "rds:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# attach policy to default role
resource "aws_iam_role_policy_attachment" "ha-web" {
  role = "${aws_iam_role.ha-web.name}"
  policy_arn = "${aws_iam_policy.ha-web.arn}"
}

# create ha-web IAM instance profile
resource "aws_iam_instance_profile" "ha-web" {
  name = "${var.name_prefix}-ha-webInstanceProfile"
  role = "${aws_iam_role.ha-web.name}"
}