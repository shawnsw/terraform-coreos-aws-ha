variable "instance_type" { default = "t2.micro" }
variable "web_docker_image" { default = "nginx" }
variable "name_prefix" { default = "ha-web" }
variable "vpc_id" { default = "vpc-xxxxxxxx" }
variable "subnet_a" { default = "subnet-xxxxxxxx" }
variable "subnet_b" { default = "subnet-xxxxxxxx" }
variable "subnet_c" { default = "subnet-xxxxxxxx" }