# # Random password
# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# # Secret
# resource "aws_secretsmanager_secret" "cred8" {
#   name = "gogreen-secret"
# }

# # Secret version
# resource "aws_secretsmanager_secret_version" "cred-ver" {
#   secret_id = aws_secretsmanager_secret.cred8.id
#   secret_string = jsonencode({
#     username = "dbadmin"
#     password = random_password.password.result
#     host     = aws_db_instance.gogreen_db.endpoint
#   })
# }

# # Create an RDS instance
# resource "aws_db_instance" "gogreen_db" {

#   identifier = "gogreen-db"

#   db_name           = "gogreenDB"
#   engine            = "mysql"
#   engine_version    = "5.7"
#   instance_class    = "db.t2.micro"
#   allocated_storage = 20

#   username = "admin"
#   password = random_password.password.result
#   port     = 3306

#   multi_az = true
#   #availability_zone    = "us-west-2a"
#   publicly_accessible     = false
#   skip_final_snapshot     = true
#   backup_retention_period = 2

#   db_subnet_group_name   = "example-db-subnet-group"
#   vpc_security_group_ids = [module.datatier_sg.security_group_id["datatier_sg"]]

#   timeouts {
#     create = "3h"
#     delete = "3h"
#     update = "3h"
#   }
# }

# # Create a read replica in another availability zone
# resource "aws_db_instance" "example_replica" {

#   identifier = "ee-instance-replica"

#   replicate_source_db        = aws_db_instance.gogreen_db.identifier
#   auto_minor_version_upgrade = false
#   instance_class             = "db.t2.micro"

#   multi_az            = false
#   publicly_accessible = false
#   skip_final_snapshot = true
#   storage_encrypted   = true

#   backup_retention_period = 2
#   vpc_security_group_ids  = [module.datatier_sg.security_group_id["datatier_sg"]]

#   timeouts {
#     create = "3h"
#     delete = "3h"
#     update = "3h"
#   }
# }

# # Output
# output "subnet_group_name" {
#   value = aws_db_subnet_group.example.name
# }

# # Subnet 3a private for main DB
# resource "aws_subnet" "subnet_pvt_3a" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.5.0/24"
#   availability_zone       = "us-west-2a" # Replace with the desired availability zone
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "gogreen-subnet_pvt_3a"
#   }
# }

# # Subnet 3b private for replica DB
# resource "aws_subnet" "subnet_pvt_3b" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.6.0/24"
#   availability_zone       = "us-west-2b" # Replace with the desired availability zone
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "gogreen-subnet_pvt_3b"
#   }
# }

# # Subnet group
# resource "aws_db_subnet_group" "example" {
#   name       = "example-db-subnet-group"
#   subnet_ids = [aws_subnet.subnet_pvt_3a.id, aws_subnet.subnet_pvt_3b.id]
# }

# # Route Table (2) Private subnets 3a, 3b
# resource "aws_route_table" "rt_private_3a_3b" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.gw-pub-1b.id
#   }
#   tags = {
#     Name = "gogreen-private AZone us-west-3a, us-west-3b"
#   }
# }

# # Route table Assosiation(1) Private subnets 3a
# resource "aws_route_table_association" "rta_pvt_3a" {
#   subnet_id      = aws_subnet.subnet_pvt_3a.id
#   route_table_id = aws_route_table.rt_private_3a_3b.id
# }

# # Route table Assosiation(1) Private subnets 3b
# resource "aws_route_table_association" "rta_pvt_3b" {
#   subnet_id      = aws_subnet.subnet_pvt_3b.id
#   route_table_id = aws_route_table.rt_private_3a_3b.id
# }

# #Outputs:

# output "db_password" {
#   value = random_password.password.result  
#   sensitive = true
# }

# output "db_endpoint" {
#   value = aws_db_instance.gogreen_db.endpoint
# }

# output "db_username" {
#   value = aws_db_instance.gogreen_db.username  
# }

# output "db_name" {
#   value = aws_db_instance.gogreen_db.db_name  
# }