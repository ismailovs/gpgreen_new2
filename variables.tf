#prefix
variable "prefix" {
  type    = string
  default = "gogreen"
}

#subnet
variable "pub_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}
}
variable "pvt_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {}
}
#Security group
variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
    })))
    egress_rules = optional(list(object({
      description     = optional(string)
      priority        = optional(number)
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      security_groups = optional(list(string))
    })))
  }))
  default = {}
}
variable "users" {
  type = map(object({
    name = string
  }))
  default = {}
}

# route 53 variables
  variable "domain_name" {
  default         = "h2order.com"
  description     = "domain name"
  type            = string
  }

  # route 53 variables
  variable "record_name" {
  default         = "www"
  description     = "sub domain name"
  type            = string
  }