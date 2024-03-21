provider "aws" {
  region = "us-east-1"
  alias  = "use_default_region"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "morningnews_frontend_preprod" {
  bucket        = "morningnews-frontend-${random_string.random.result}"
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}


# resource "aws_s3_bucket_ownership_controls" "morningnews_frontend_preprod_bucket_ownership_controls" {
#   bucket = aws_s3_bucket.morningnews_frontend_preprod.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

resource "aws_s3_bucket_public_access_block" "morningnews_frontend_preprod_public_access_block" {
  bucket = aws_s3_bucket.morningnews_frontend_preprod.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.morningnews_frontend_preprod.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.morningnews_frontend_preprod_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "morningnews_frontend_preprod_bucket_policy" {
  bucket = aws_s3_bucket.morningnews_frontend_preprod.id
  policy = data.aws_iam_policy_document.website_bucket.json
}


output "bucket_name" {
  value = aws_s3_bucket.morningnews_frontend_preprod.bucket
}
