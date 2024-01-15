#Bastion host instance

resource "aws_instance" "bastion" {
  ami                    = "ami-01450e8988a4e7f44"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.id
  subnet_id              = aws_subnet.bastion.id
  vpc_security_group_ids = [module.bastion_sg.security_group_id["bastion_sg1"]]
  tags = {
    Name = "bastion_host"
  }
}

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.24.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = join("-", [var.prefix, "bastion"])
  }
}


