resource "aws_cloudfront_distribution" "website" {
  enabled  = true

  aliases = [aws_route53_zone.root.name, "www.${aws_route53_zone.root.name}"]

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
    #http://herodot-infra-company-prod-website.s3-website-us-west-1.amazonaws.com/
    domain_name = "${aws_s3_bucket.website.id}.s3-website-${aws_s3_bucket.website.region}.amazonaws.com"
    origin_id   = "S3-${aws_s3_bucket.website.id}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.root_domain.arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = "false"
  }

  is_ipv6_enabled = true
}
