# While it's not clean, it's better than some unmaintainable hackiness.
# SES always returns 3 tokens, so rather than looping over them, we can just hardcode each record.
resource "aws_route53_record" "dkim_1" {
  count = var.hosted_zone_id != null ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[0]}._domainkey"
  type    = "CNAME"
  records = ["${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[0]}.dkim.amazonses.com"]
  ttl     = 1800
}

resource "aws_route53_record" "dkim_2" {
  count = var.hosted_zone_id != null ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[1]}._domainkey"
  type    = "CNAME"
  records = ["${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[1]}.dkim.amazonses.com"]
  ttl     = 1800
}

resource "aws_route53_record" "dkim_3" {
  count = var.hosted_zone_id != null ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[2]}._domainkey"
  type    = "CNAME"
  records = ["${aws_sesv2_email_identity.this.dkim_signing_attributes[0].tokens[2]}.dkim.amazonses.com"]
  ttl     = 1800
}
