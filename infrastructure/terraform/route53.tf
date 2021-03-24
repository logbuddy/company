resource "aws_route53_zone" "root" {
  name = lookup(var.workspace_to_root_domain, terraform.workspace)
}

data "aws_route53_zone" "webapp_root" {
  provider = aws.infra_webapp
  name = "app.${aws_route53_zone.root.name}"
}

resource "aws_route53_record" "root_webapp_subdomain" {
  name = "app"
  type = "NS"
  zone_id = aws_route53_zone.root.id
  records = [
    data.aws_route53_zone.webapp_root.name_servers[0],
    data.aws_route53_zone.webapp_root.name_servers[1],
    data.aws_route53_zone.webapp_root.name_servers[2],
    data.aws_route53_zone.webapp_root.name_servers[3],
  ]
}
