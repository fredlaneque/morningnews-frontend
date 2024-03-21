#cloudfront distribution
resource "aws_cloudfront_distribution" "morningnews_frontend_prod_distribution" {
  aliases = ["${data.aws_route53_zone.selected.name}", "www.${data.aws_route53_zone.selected.name}"]
  origin {
    domain_name              = aws_s3_bucket.morningnews_frontend_prod.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.morningnews_frontend_prod.bucket}"
    origin_access_control_id = aws_cloudfront_origin_access_control.default_prod.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.morningnews_frontend_prod.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert_prod.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


resource "aws_cloudfront_origin_access_control" "default_prod" {
  name                              = "cloudfront OAC prod"
  description                       = "description OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


output "cloudfront_url" {
  value = aws_cloudfront_distribution.morningnews_frontend_prod_distribution.domain_name
}
