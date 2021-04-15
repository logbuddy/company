resource "aws_route53_zone" "root" {
  name = lookup(var.workspace_to_root_domain, terraform.workspace)
}

resource "aws_route53_record" "root_cloudfront_alias" {
  name = ""
  type = "A"
  zone_id = aws_route53_zone.root.id
  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.website.domain_name
    zone_id = aws_cloudfront_distribution.website.hosted_zone_id
  }
}

resource "aws_route53_record" "root_cloudfront_alias_www" {
  name = "www"
  type = "A"
  zone_id = aws_route53_zone.root.id
  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.website.domain_name
    zone_id = aws_cloudfront_distribution.website.hosted_zone_id
  }
}


data "aws_route53_zone" "infra_webapp_prod_subdomain" {
  provider = aws.infra_webapp
  name = "app.${aws_route53_zone.root.name}"
}

# This delegates app.logbuddy.io to the Route53 zone app.logbuddy.io in account herodot-infra-webapp-prod.
# Therefore, this terraform depends on https://github.com/logbuddy/webapp/blob/main/infrastructure/terraform/bootstrap/route53.tf,
# where the Route53 zone app.logbuddy.io is defined and whose NS records we reference here.
# When building the infrastructure from scratch, you therefore need to first terraform
# https://github.com/logbuddy/webapp/blob/main/infrastructure/terraform/bootstrap, and then this project.
resource "aws_route53_record" "infra_webapp_prod_subdomain" {
  name = "${data.aws_route53_zone.infra_webapp_prod_subdomain.name}."
  type = "NS"
  zone_id = aws_route53_zone.root.id
  ttl = 900
  records = [
    data.aws_route53_zone.infra_webapp_prod_subdomain.name_servers[0],
    data.aws_route53_zone.infra_webapp_prod_subdomain.name_servers[1],
    data.aws_route53_zone.infra_webapp_prod_subdomain.name_servers[2],
    data.aws_route53_zone.infra_webapp_prod_subdomain.name_servers[3],
  ]
}
