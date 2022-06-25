//resource "aws_route53_record" "www" {
//  zone_id = data.aws_route53_zone.selected.zone_id
//  name    = "gitlab.${data.aws_route53_zone.selected.name}"
//  type    = "A"
//  ttl     = "300"
//  records = [aws_instance.gitlab.public_ip]
//}
