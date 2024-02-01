#subnets:
#subnet_pub_1a: bastion, nat, webtier AZone1
#subnet_pub_1b: nat, webtier AZone2
#subnet_pub_2a: apptier AZone1
#subnet_pub_2b: apptier AZone2
#subnet_pub_3a: datatier AZone1
#subnet_pub_3b: datatier AZone1

pub_subnets = {
  subnet_pub_1a = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-2a"
  },
  subnet_pub_1b = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-west-2b"
  }
}
pvt_subnets = {
  subnet_pvt_2a = {
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-west-2a"
  },
  subnet_pvt_2b = {
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-west-2b"
  }
  # subnet_pvt_3a = {
  #   cidr_block        = "10.0.5.0/24"
  #   availability_zone = "us-west-2a"
  # },
  # subnet_pvt_3b = {
  #   cidr_block        = "10.0.6.0/24"
  #   availability_zone = "us-west-2b"
  # }
}

# users = {
#   sysadmin1 = {
#     name = "sysadmin1"
#   },
#   sysadmin2 = {
#     name = "sysadmin2"
#   },
#   dbadmin1 = {
#     name = "dbadmiin1"
#   },
#   dbadmin2 = {
#     name = "dbadmiin2"
#   },
#   monitor1 = {
#     name = "monitor1"
#   },
#   monitor2 = {
#     name = "monitor2"
#   },
#   monitor3 = {
#     name = "monitor3"
#   },
#   monitor4 = {
#     name = "monitor4"
#   }
# }
