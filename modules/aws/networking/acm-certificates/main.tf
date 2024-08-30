resource "aws_acm_certificate" "this" {
  for_each = local.acm_certificates

  domain_name               = trimsuffix(each.key, ".")
  subject_alternative_names = each.value.subject_alternative_names
  validation_method         = "DNS"

  tags = var.tags_all

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for domain, source_domain in local.lookup_from_domain_to_source_for_dns_record_creation :
    domain => domain
  }

  name            = local.dns_verification_record_data[each.value].validation_options[0].resource_record_name
  type            = local.dns_verification_record_data[each.value].validation_options[0].resource_record_type
  zone_id         = local.dns_verification_record_data[each.value].zone_id
  allow_overwrite = true
  ttl             = 60
  records = [
    local.dns_verification_record_data[each.value].validation_options[0].resource_record_value
  ]
}

resource "aws_acm_certificate_validation" "cert" {
  for_each = {
    for key, c in aws_acm_certificate.this :
    key => c if local.acm_certificates[key].create_verification_record
  }

  certificate_arn         = each.value.arn
  validation_record_fqdns = each.value.domain_validation_options[*].resource_record_name
}

locals {
  acm_certificates = {
    for domain, cert in var.certificates : domain => {
      subject_alternative_names  = cert.subject_alternative_names
      create_verification_record = var.zone_id != null && cert.create_verification_record
    }
  }

  list_of_all_domains_to_create_dns_records_for = flatten([
    for key, d in local.acm_certificates : concat([key], d.subject_alternative_names) if d.create_verification_record
  ])

  list_of_all_source_domains_to_create_dns_records_for = flatten([
    for key, d in local.acm_certificates : concat([key], [for san in d.subject_alternative_names : key]) if d.create_verification_record
  ])

  lookup_from_domain_to_source_for_dns_record_creation = zipmap(
    local.list_of_all_domains_to_create_dns_records_for,
    local.list_of_all_source_domains_to_create_dns_records_for
  )

  dns_verification_record_data = {
    for domain, source_domain in local.lookup_from_domain_to_source_for_dns_record_creation :
    domain => {
      validation_options = [
        for domain_validation_options in aws_acm_certificate.this[source_domain].domain_validation_options :
        domain_validation_options if lower(domain_validation_options.domain_name) == lower(domain)
      ]
      zone_id = var.zone_id
    }
  }
}
