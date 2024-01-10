# Launch Template for webtier ASG
resource "aws_launch_template" "template-web" {
  name_prefix            = "webtier-instance"
  image_id               = "ami-01450e8988a4e7f44"
  key_name               = aws_key_pair.key.id
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/web.sh")
  vpc_security_group_ids = [module.webtier_sg.security_group_id["webtier_sg"]]
  tags = {
    Name = "${var.prefix}-web_lt"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web instance"
    }
  }
}
#Auto Scaling Group web-1
resource "aws_autoscaling_group" "asg-1a" {
  name                 = "autoscaling-group-webtier-1a"
  vpc_zone_identifier  = [aws_subnet.pub_subnet["subnet_pub_1a"].id]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [aws_lb_target_group.target_group_web.arn]
  launch_template {
    id      = aws_launch_template.template-web.id
    version = "$Latest"
  }

}
#Auto Scaling Group web-2
resource "aws_autoscaling_group" "asg-1b" {
  name                 = "autoscaling-group-webtier-1b"
  vpc_zone_identifier  = [aws_subnet.pub_subnet["subnet_pub_1b"].id]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [aws_lb_target_group.target_group_web.arn]
  launch_template {
    id      = aws_launch_template.template-web.id
    version = "$Latest"
  }
}

#Application LB for webtier
resource "aws_lb" "webtier_alb" {
  name                       = "web-lb-tf"
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  security_groups            = [module.webtier_alb_sg.security_group_id["webtier_alb_sg"]]
  subnets                    = [aws_subnet.pub_subnet["subnet_pub_1a"].id, aws_subnet.pub_subnet["subnet_pub_1b"].id]
  enable_deletion_protection = false
  tags = {
    name = "gogreen_ALB_web"
  }
}

# Target Group for webtier Application LB
resource "aws_lb_target_group" "target_group_web" {
  name        = "web-tg" 
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
    Name = "${var.prefix}-target_group_web"
  }
    stickiness {
    type            = "lb_cookie"
    cookie_duration = 120
  }
}

# Listener for Application LB of webtier
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.webtier_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.target_group_web.arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "apptier_asa_1a" {
  autoscaling_group_name = aws_autoscaling_group.asg-1a.id
  lb_target_group_arn    = aws_lb_target_group.target_group_web.arn
}

resource "aws_autoscaling_attachment" "apptier_asa_1b" {
  autoscaling_group_name = aws_autoscaling_group.asg-1b.id
  lb_target_group_arn    = aws_lb_target_group.target_group_web.arn
}

# Output
output "elb-web-dns-name" {
  value = aws_lb.webtier_alb.dns_name
}
