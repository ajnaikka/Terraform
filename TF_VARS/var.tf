variable region {
  type        = string
  default     = "ap-south-1"
  description = "description"
}

variable ami {
  type        = string
  default     = "ami-01216e7612243e0ef"
  description = "description"
}

variable instance_count {
  type        = number
  default     = "1"
  description = "Instance number to be created"
}
 
variable instancetype {
  type        = string
  default     = "t2.micro"
  description = "type for instance required"
}

