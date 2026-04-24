####################################################
####################################################

## 1. This tf configuration creates an s3 bucket

####################################################
####################################################

resource aws_s3_bucket "static_bucket" {
    bucket = var.bucket_name
    # region = "us-east-1"
}


####################################################
####################################################

## 2. This tf configuration  adds public access block to s3 bucket

####################################################
####################################################

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

####################################################
####################################################

## 3. This tf configuration creates cloudfornt origin access control for s3 bucket

####################################################
####################################################
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "demo-oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

####################################################
####################################################
## 4. This tf configuration creates bucket policy to allow cdn to access s3 bucket
####################################################
####################################################
resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = aws_s3_bucket.static_bucket.id
  depends_on = [ aws_s3_bucket_public_access_block.block ]
  
policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Sid    = "Allow_cloudfornt"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = [
        "s3:GetObject",
        # "s3:ListBucket"
        ]
      Resource = "${aws_s3_bucket.static_bucket.arn}/*"
    #  Condition = {
    #    StringEquals = {
    #      "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
    #    }
    #  }
    }
  ]
})
}

####################################################
####################################################

## 5. This tf configuration creates object in s3 and upload file to s3 bucket

####################################################
####################################################

# resource "aws_s3_object" "object" {
#   bucket = aws_s3_bucket.static_bucket.bucket
#   for_each = fileset(var.file_path, "**")
#   key    = each.value
# #   source = "${var.file_path}/${each.value}"
# #   etag = filemd5("${var.file_path}/${each.value}")



resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.static_bucket.bucket

  for_each = fileset("${path.module}/${var.file_path}", "**")

  key    = each.value
  source = "${path.module}/${var.file_path}/${each.value}"
  etag   = filemd5("${path.module}/${var.file_path}/${each.value}")

content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      json = "application/json"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
      svg  = "image/svg+xml"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}

####################################################
####################################################

## 6. This tf configuration creates cloudfront distribution with s3 bucket as origin and ACM certificate for SSL

####################################################
####################################################
resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name              = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  aliases = [
   var.my_domain,                 # altamash.cloud
  "project.${var.my_domain}"     
]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

####################################################
####################################################

# 7. Create ACM Certificate

####################################################
####################################################

resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = var.my_domain
  validation_method = "DNS"

  subject_alternative_names = [

    "project.${var.my_domain}"
    
    ]

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Data Source for already have a domain in Route53

data "aws_route53_zone" "main" {
  name         = var.my_domain
  private_zone = false
}

####################################################
####################################################

# 8. Validate Certificate via Route53

####################################################
####################################################


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.main.zone_id

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}
# Activate the Certificate.
resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

}

####################################################
####################################################

# 9. Create Route53 Record (Domain → CloudFront)

####################################################
####################################################
resource "aws_route53_record" "cdn_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "project.${var.my_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}