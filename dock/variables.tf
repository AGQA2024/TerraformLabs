variable ec2_size {
  type = string
  default = "t3.micro"
  description = "The ec2 type"
}

variable ec2_az {
  type = string
# Then in the resource -> var.ec2_az
}

variable access_key {
    type = string
}

variable secret_key {
  type = string
}