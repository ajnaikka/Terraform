
variable instancetype {
  type        = string
  default     = "t2.micro"
  description = "type for instance required"
}

variable ami {
  type        = string
  default     = "ami-06672d07f62285d1d"
  description = "DEV-AMI"
}
