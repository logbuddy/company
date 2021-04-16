resource "aws_s3_bucket" "website" {
  bucket = "herodot-infra-company-prod-website"
  force_destroy = "false"
  website {
    redirect_all_requests_to = "https://app.logbuddy.io"
  }
  acl = "public-read"
}

resource "aws_s3_bucket_object" "website_content" {
  for_each = fileset("../../src", "*.html")
  bucket = aws_s3_bucket.website.id
  key = each.value
  source = "../../src/${each.value}"
  etag = filemd5("../../src/${each.value}")
  content_type = "text/html"
  acl = "public-read"
}
