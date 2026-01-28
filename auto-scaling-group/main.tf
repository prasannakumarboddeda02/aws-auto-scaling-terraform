resource "aws_launch_template" "instance-template" {
  name_prefix   = "instance-template"
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]  # ✅ THIS
  }

  user_data = filebase64("./userdata.tpl")
}

resource "aws_autoscaling_group" "ASG" {
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  vpc_zone_identifier = var.subnets

  health_check_type = "ELB"

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.instance-template.id
    version = "$Latest"
  }
}
