data "aws_iam_openid_connect_provider" "github" {
  count = var.create_openid_connect_provider ? 0 : 1
  arn   = "arn:aws:iam::${data.aws_caller_identity.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

data "tls_certificate" "github" {
  count = var.create_openid_connect_provider ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  count           = var.create_openid_connect_provider ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github[0].certificates[0].sha1_fingerprint]
}
