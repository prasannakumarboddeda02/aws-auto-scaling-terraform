output "default_subnets"{
    value = data.aws_subnets.default.ids
}

output "load_balancer_dns"{
    value = "http://${module.load-balancer.DNS}"
}