# resource "aws_route53_zone" "gogreen" {
#   name     = "vimpire.org"
# }

# resource "aws_route53_record" "nameservers" {
#   allow_overwrite = true
#   name            = "vimpire.org"
#   ttl             = 3600
#   type            = "NS"
#   zone_id         = aws_route53_zone.gogreen.zone_id

#   records = aws_route53_zone.gogreen.name_servers
# }