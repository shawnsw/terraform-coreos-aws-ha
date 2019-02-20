# create SSH private key
resource "tls_private_key" "ssh" {
  algorithm   = "RSA"
  rsa_bits     = 4096
}

# generate aws keypair with public key exported from tls_private_key
resource "aws_key_pair" "ssh" {
  key_name   = "${var.name_prefix}-key"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}