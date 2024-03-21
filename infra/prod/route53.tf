data "aws_route53_zone" "selected" {
  provider     = aws.use_default_region
  name         = "codecrafters-morningnews.com"
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.use_default_region
  #  prodiver = aws.us-east-1
  for_each = {
    for dvo in aws_acm_certificate.cert_prod.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
  ttl             = 60
}


resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"

  # Alias record pointing to CloudFront distribution domain name
  alias {
    name                   = aws_cloudfront_distribution.morningnews_frontend_prod_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.morningnews_frontend_prod_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "A"

  # Alias record pointing to CloudFront distribution domain name
  alias {
    name                   = aws_cloudfront_distribution.morningnews_frontend_prod_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.morningnews_frontend_prod_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

output "access_url" {
  value = "${data.aws_route53_zone.selected.name}"
}
