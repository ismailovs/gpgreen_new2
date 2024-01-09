# Create an RDS instance
resource "aws_db_instance" "example_db" {
  identifier           = "example-db"
  db_name              = "${var.prefix}-db"
  engine               = "mysql" # Choose your desired database engine
  engine_version       = "5.7"
  instance_class       = "db.t2.micro" # Choose your desired instance type
  allocated_storage    = 20
  username             = "admin"
  password             = "password"
  port                 = 3306
  multi_az             = true         # Enable multi-AZ deployment
  availability_zone    = "us-west-2a" # Specify the primary availability zone
  publicly_accessible  = false
  skip_final_snapshot  = true
  #db_subnet_group_name = [aws_subnet.pvt_subnet["subnet_pvt_3a"].id, aws_subnet.pvt_subnet["subnet_pvt_3b"].id]
  db_subnet_group_name = "example-db-subnet-group"
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

# Create a read replica in another availability zone
resource "aws_db_instance" "example_replica" {
  identifier          = "example-replica"
  replicate_source_db = aws_db_instance.example_db.id
  replica_mode        = "mounted"
  instance_class      = "db.t2.micro" # Choose your desired instance type
  allocated_storage   = 20
  username            = "admin"
  password            = "password"
  port                = 3306
  multi_az            = true         # Enable multi-AZ deployment
  availability_zone   = "us-west-2b" # Specify the replica availability zone
  publicly_accessible = false
  skip_final_snapshot = true
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "example-db-subnet-group"
  subnet_ids =[aws_subnet.pvt_subnet["subnet_pvt_3a"].id, aws_subnet.pvt_subnet["subnet_pvt_3b"].id]
  #subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

 # db_subnet_group_name = "example-db-subnet-group"


# resource "aws_db_instance" "default" {
#   allocated_storage           = 30
#   auto_minor_version_upgrade  = false                         # Custom for Oracle does not support minor version upgrades
#   custom_iam_instance_profile = "AWSRDSCustomInstanceProfile" # Instance profile is required for Custom for Oracle. See: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-orcl.html#custom-setup-orcl.iam-vpc
#   backup_retention_period     = 7
#   db_subnet_group_name        = [aws_subnet.pvt_subnet["subnet_pvt_3a"].id, aws_subnet.pvt_subnet["subnet_pvt_3b"].id]
#   engine                      = "mysql" # Choose your desired database engine
#   engine_version              = "5.7"
#   identifier                  = "ee-instance-demo"
#   instance_class              = "db.t2.micro" # Choose your desired instance type
#   #kms_key_id                  = data.aws_kms_key.by_id.arn
#   multi_az          = true
#   password          = "avoid-plaintext-passwords"
#   username          = "test"
#   storage_encrypted = true


# }

# resource "aws_db_instance" "test-replica" {
#   replicate_source_db         = aws_db_instance.default.identifier
#   replica_mode                = "mounted"
#   auto_minor_version_upgrade  = false
#   custom_iam_instance_profile = "AWSRDSCustomInstanceProfile" # Instance profile is required for Custom for Oracle. See: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-orcl.html#custom-setup-orcl.iam-vpc
#   backup_retention_period     = 7
#   identifier                  = "ee-instance-replica"
#   instance_class              = "db.t2.micro" # Choose your desired instance type
#   # kms_key_id                  = data.aws_kms_key.by_id.arn
#   multi_az            = true
#   skip_final_snapshot = true
#   storage_encrypted   = true

#   timeouts {
#     create = "3h"
#     delete = "3h"
#     update = "3h"
#   }
# }