#Bastion host instance

resource "aws_instance" "bastion" {
  ami             = "ami-01450e8988a4e7f44"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.bastion-key.id
  subnet_id       = aws_subnet.pub_subnet["subnet_pub_1a"].id
  security_groups = [module.bastion_sg.security_group_id["bastion_sg"]]
  tags = {
    Name = "bastion_host"
  }
}

# Key pair
resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}