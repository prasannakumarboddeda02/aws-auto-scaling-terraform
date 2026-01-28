resource "aws_lb" "load_balancer" {
  name               = "lb"
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "app_tg" {
  name = "app-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/health"
    protocol = "HTTP"
    port = "80"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}