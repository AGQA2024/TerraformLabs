# variable "deployment_region" {
#   description = "Region of deployment"
#   type        = string
#   default     = "us-west-1"
# }
# # Will fail at this stage due to AZ knock on

# variable "region_az" {
#   description = "Availability Zone"
#   type        = string
#   default     = "us-west-1a"
# }
# # Will fail at this stage due to AMI knock on

# variable "instance_ami" {
#   description = "EC2 ami"
#   type        = string
#   default     = "ami-0036b4598ccd42565"
# }

# variable "ec2_instance_size" {
#   description = "EC2 size"
#   type        = string
# #   default     = "t2.micro"
#   default     = "variable file sized"
# }

# terraform plan -var "ec2_instance_size=t1.micro" -var "instance_ami=ami-0d50e5e845c552faf" -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json

# To check what variables would be used by TF:
# terraform plan -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json
# The nano editor isn't easy to navigate...

