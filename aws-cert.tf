# create private key
resource "tls_private_key" "certificate" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# create self signed cert
resource "tls_self_signed_cert" "certificate" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.certificate.private_key_pem}"

  subject {
    common_name  = "ha-web.example.com"
    organization = "ha-web"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# create acm cert
resource "aws_acm_certificate" "certificate" {
  private_key      = "${tls_private_key.certificate.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.certificate.cert_pem}"
}
