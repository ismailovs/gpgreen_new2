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

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}