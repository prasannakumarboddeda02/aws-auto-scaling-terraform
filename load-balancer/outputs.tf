output "target_group_arn"{
    value = aws_lb_target_group.app_tg.arn
}

output "DNS"{
    value = aws_lb.load_balancer.dns_name
}