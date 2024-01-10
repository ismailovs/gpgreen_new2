# Launch Template for apptier ASG
resource "aws_launch_template" "template-app" {
  name_prefix            = "apptier-instance"
  image_id               = "ami-01450e8988a4e7f44"
  key_name               = aws_key_pair.key.id
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/web.sh")
  vpc_security_group_ids = [module.apptier_sg.security_group_id["apptier_sg"]]
  tags = {
    Name = "${var.prefix}-apptier_alb_lt"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app instance"
    }
  }
}
#Auto Scaling Group app-1
resource "aws_autoscaling_group" "asg-2a" {
  name                 = "autoscaling-group-apptier-2a"
  vpc_zone_identifier  = [aws_subnet.pvt_subnet["subnet_pvt_2a"].id]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [aws_lb_target_group.target_group_app.arn]
  launch_template {
    id      = aws_launch_template.template-app.id
    version = "$Latest"
  }
}
#Auto Scaling Group app-2
resource "aws_autoscaling_group" "asg-2b" {
  name                 = "autoscaling-group-apptier-2b"
  vpc_zone_identifier  = [aws_subnet.pvt_subnet["subnet_pvt_2b"].id]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [aws_lb_target_group.target_group_app.arn]
  launch_template {
    id      = aws_launch_template.template-app.id
    version = "$Latest"
  }
}

#Application LB for apptier
resource "aws_lb" "apptier_alb" {
  name                       = "app-lb-tf"
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  security_groups            = [module.apptier_alb_sg.security_group_id["apptier_alb_sg"]]
  subnets                    = [aws_subnet.pvt_subnet["subnet_pvt_2a"].id, aws_subnet.pvt_subnet["subnet_pvt_2b"].id]
  enable_deletion_protection = false
  tags = {
    name = "${var.prefix}-ALB_app"
  }
}

# Target Group for apptier Application LB
resource "aws_lb_target_group" "target_group_app" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
  health_check {
    interval            = 100
    path                = "/"
    timeout             = 50
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = {
    Name = "${var.prefix}-target_group_app"
  }
}

# Listener for Application LB of apptier
resource "aws_lb_listener" "alb_listener_apptier" {
  load_balancer_arn = aws_lb.apptier_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target_group_app.arn
    type             = "forward"
  }
  tags = {
    Name = "${var.prefix}-apptier_alb_listener"
  }
}

# Output
output "elb-app-dns-name" {
  value = aws_lb.apptier_alb.dns_name
}

