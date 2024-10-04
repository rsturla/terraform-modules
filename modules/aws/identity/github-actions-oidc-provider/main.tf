data "aws_partition" "current" {}

data "tls_certificate" "this" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = data.tls_certificate.this.url
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = data.tls_certificate.this.certificates[*].sha1_fingerprint

  tags = var.tags_all
}
