# Security Group for Bastion-host
module "bastion_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "bastion_sg" : {
      description = "Security group for bastion host"
      ingress_rules = [
        {
          description = "ssh"
          priority    = 202
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 203
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# Security Group for webtier
module "webtier_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "webtier_sg" : {
      description = "Security group for web servers"
      ingress_rules = [
        {
          description = "ingress rule for http"
          priority    = 207
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "ingress rule for https"
          priority    = 209
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description     = "my_ssh"
          priority        = 208
          from_port       = 22
          to_port         = 22
          protocol        = "tcp"
          security_groups = [module.bastion_sg.security_group_id["bastion_sg"]]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 210
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# Security Group for web application load balancer
module "webtier_alb_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "webtier_alb_sg" : {
      description = "Security group for Application Load Balancer at web servers"
      ingress_rules = [
        {
          description = "ingress rule for http"
          priority    = 204
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "ingress rule for https"
          priority    = 204
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 206
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# Security Group for apptier
module "apptier_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "apptier_sg" : {
      description = "Security group for app servers"
      ingress_rules = [
        {
          description     = "ingress rule for http"
          priority        = 215
          from_port       = 8080
          to_port         = 8080
          protocol        = "tcp"
          security_groups = [module.webtier_sg.security_group_id["webtier_sg"]]
        },
        {
          description     = "my_ssh"
          priority        = 216
          from_port       = 22
          to_port         = 22
          protocol        = "tcp"
          security_groups = [module.bastion_sg.security_group_id["bastion_sg"]]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 217
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# Security Group for app application load balancer
module "apptier_alb_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "apptier_alb_sg" : {
      description = "Security group for Application Load Balancer at app servers"
      ingress_rules = [
        {
          description     = "ingress rule for http"
          priority        = 211
          from_port       = 8080
          to_port         = 8080
          protocol        = "tcp"
          security_groups = [module.webtier_sg.security_group_id["webtier_sg"]]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 214
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# Security Group for datatier
module "datatier_sg" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.main.id
  security_groups = {
    "datatier_sg" : {
      description = "Security group for datatier servers"
      ingress_rules = [
        {
          description     = "ingress rule for DB MySQL"
          priority        = 618
          from_port       = 3306
          to_port         = 3306
          protocol        = "tcp"
          security_groups = [module.apptier_sg.security_group_id["apptier_sg"]]
        }
      ]
      egress_rules = [
        {
          description = "egress rule"
          priority    = 219
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}