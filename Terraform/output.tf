output "test" {
  value = "test"
}

output "nlb_dns_name" {
  value = module.nlb.dns_name
}

output "route53_records" {
  value = module.nlb.route53_records
}