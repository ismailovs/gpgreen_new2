# resource "aws_route53_zone" "gogreen" {
#   name     = var.domain_name
# }
 
# resource "aws_route53_record" "nameservers" {
#   allow_overwrite = true
#   name            = var.record_name
#   type            = "A"
#   zone_id         = aws_route53_zone.gogreen.zone_id
 
#  alias {
#    name = aws_lb.webtier_alb.dns_name
#    zone_id = aws_lb.webtier_alb.zone_id
#    evaluate_target_health = true
#  }
# }