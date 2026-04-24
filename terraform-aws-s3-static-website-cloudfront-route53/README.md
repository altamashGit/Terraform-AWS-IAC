# AWS Static Website Hosting with S3, CloudFront, Route53, and Terraform

## 📌 Project Overview
This project demonstrates how to deploy a **highly available,secure and scalable static website** using AWS services, fully automated with Terraform.

### 🚀 Services Used:  

Amazon S3 as a private origin for static content  
Amazon CloudFront for global content delivery (CDN)  
AWS Certificate Manager (ACM) for HTTPS  
Amazon Route53 for DNS routing  

The infrastructure is fully automated using Infrastructure as Code (IaC).  

---

##  Architecture

<img width="1777" height="644" alt="image-1" src="https://github.com/user-attachments/assets/ce95546e-70dc-4006-8001-342d0faf3ebf" />


---

Architecture Flow

<img width="1448" height="1086" alt="flow-2" src="https://github.com/user-attachments/assets/e597eaee-6df3-4313-81d2-a830a8442ac9" />


---

## Key Features:   
 . Secure static hosting using private S3 bucket  
 . CloudFront CDN for low-latency global delivery   
 . HTTPS enabled using ACM (TLS 1.2)  
 . Route53 domain routing with alias record  
 . Origin Access Control (OAC) to restrict direct S3 access  
 . Automated file upload using Terraform (aws_s3_object)  

---

## Terraform Resources Used :
 . aws_s3_bucket  
 . aws_s3_bucket_public_access_block  
 . aws_s3_bucket_policy  
 . aws_s3_object  
 . aws_cloudfront_distribution  
 . aws_cloudfront_origin_access_control  
 . aws_acm_certificate  
 . aws_acm_certificate_validation  
 . aws_route53_record  

 ---


### main.tf

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.42.0"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

```

 ---

### S3 BUCKET CREATION

s3_bucket.tf

```bash
## S3 BUCKER
resource aws_s3_bucket "static_bucket" {
    bucket = var.bucket_name
    # region = "us-east-1"
}

# S3 Block access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 object copy static website meterial

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

# Bucket ploy
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
    }
  ]
})
}

```


### CloudFront Distribution

cloudfront.tf

```bash

# CloudFront Distributions with with s3 bucket as origin and ACM certificate for SSL
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
```
---
### Route 53 ACM and domain Mapping with SSL certification

```bash

# 1. Data Source for already have a domain in Route53

data "aws_route53_zone" "main" {
  name         = var.my_domain
  private_zone = false
}

# 2. Create ACM Certificate

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


# 3. Validate Certificate via Route53

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


# 4. Create Route53 Record (Domain → CloudFront)


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
```

---

variable.tf
```bash
variable "bucket_name" {
    description = "The nam of the s3 bucket to create"
    type    = string
    default = "project.altamash.cloud"
}

variable "file_path" {
    description = "The path to the file "
    type = string
    default = "www"
}

variable "my_domain"{
    description = "The domain name to use for cfn distribution"
    type = string
    default = "altamash.cloud"
}
```
---
local.tf

```bash
locals {
    origin_id = "s3-${aws_s3_bucket.static_bucket.id}"
    my_domain = "project.altamash.cloud"
}

```

output.tf

```bash

output "cloudfront_dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.static_bucket.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.cert.arn
}
```

---


## Deployment Steps :

1. Initialize Terraform

```bash
 terraform init
```

2. Validate Configuration

```bash
terraform validate
```

3. Plan Infrastructure

```bash
terraform plan
```
<img width="1430" height="748" alt="plan" src="https://github.com/user-attachments/assets/fb0f9091-1c45-4cf9-b63e-8b52398d0c90" />


4. Apply Changes

```bash
terraform apply
```

<img width="1142" height="885" alt="apply" src="https://github.com/user-attachments/assets/278f8c1f-4305-40dc-af50-974ddb21dfd1" />


Note : -- *If it take 4 to 5 minutes to creates infrastructure wait for it. It's normal not in your configuraion misktes*

---

### Console Check:

 ### 1. S3 Bucket
 
 <img width="1738" height="838" alt="s3-bucket-object" src="https://github.com/user-attachments/assets/9f03c973-a9e2-425b-bfa1-50fb67ec718c" />


 ### 2. S3 Bucket Policy


<img width="1725" height="858" alt="bucket-policy" src="https://github.com/user-attachments/assets/d295af28-2220-4640-ac82-874896a379c7" />


 ### 4. AWS Certificate manager


<img width="1651" height="491" alt="acm" src="https://github.com/user-attachments/assets/458c1414-d59e-41c8-8ca3-79e22a72f1da" />


 ### 5. Cloudfront


<img width="1735" height="826" alt="cloud-front" src="https://github.com/user-attachments/assets/74f17f6c-315a-4c5e-8d7c-34971d742219" />


 ### 6. Route53


<img width="1096" height="713" alt="route-53" src="https://github.com/user-attachments/assets/c4eb2105-aec8-4609-b8c3-b65b7fe63c2f" />


---

## Important Notes :
1. ACM certificate must be created in us-east-1 (required for CloudFront)
2. Domain must already exist in Route53
3. DNS validation is automated via Terraform


## Access the Website

After deployment, access your website using:

``https://project.<your-domain>``

Example:  

```bash
https://project.altamash.cloud
```

<img width="1906" height="984" alt="browser" src="https://github.com/user-attachments/assets/886eef46-a12e-47f7-8164-039cf0197ba4" />



---
Cleanup

To delete all resources:

```bash
terraform destroy -auto-approve
```

<img width="1134" height="929" alt="destory" src="https://github.com/user-attachments/assets/185b8e02-688a-44c1-8ced-9b2f1baecd8d" />

---

## Learning Outcomes  
1. Designing secure static website architecture on AWS  
2. Implementing CDN with CloudFront  
3. Managing domain and SSL using Route53 and ACM  
4. Automating infrastructure using Terraform  
5. Applying AWS security best practices (OAC, private S3)  

---
## 🏁 Wrapping Up

This project may be small, but every line of Terraform brings me closer to mastering Infrastructure as Code.

Until the next deployment 🚀

Made with ❤️ using Terraform by Altamash
---
