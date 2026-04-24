output "cloudfront_dns" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.static_bucket.id
}

# output "cloudfront_urls" {
#   value = {
#     for k, obj in aws_s3_object.object :
#     k => "https://${aws_cloudfront_distribution.s3_distribution.domain_name}/${obj.key}"
#   }
# }

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.cert.arn
}