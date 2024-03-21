resource "aws_acm_certificate" "cert_prod" {
  provider                  = aws.use_default_region
  domain_name               = data.aws_route53_zone.selected.name
  validation_method         = "DNS"
  subject_alternative_names = [data.aws_route53_zone.selected.name, "*.${data.aws_route53_zone.selected.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_prod" {
  provider                = aws.use_default_region
  certificate_arn         = aws_acm_certificate.cert_prod.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

