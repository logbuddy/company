resource "aws_cloudfront_distribution" "website" {
  enabled  = true

  aliases = [aws_route53_zone.root.name]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "S3-${aws_s3_bucket.website.id}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
    }
  }

  price_class = "PriceClass_All"

  origin {
    domain_name = aws_s3_bucket.website.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.website.id}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.root_domain.arn
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = "false"
  }

  is_ipv6_enabled = true
}
