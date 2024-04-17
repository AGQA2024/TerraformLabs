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
#   default     = "t2.micro"
# }

# variable "instance_count" {
#   description = "Number of EC2 instances in each subnet"
#   type        = number
#   default     = 2
# }

# terraform plan -var "ec2_instance_size=t1.micro" -var "instance_ami=ami-0d50e5e845c552faf" -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json

# To check what variables would be used by TF:
# terraform plan -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json
# The nano editor isn't easy to navigate...

# terraform plan --var-file=file_1.tfvars --var-file=file_2.tfvars -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json

# terraform plan --var-file=file_1.tfvars --var-file=file_2.tfvars -var="region_az=from var-input" -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json

# terraform plan --var-file=file_1.tfvars --var-file=file_2.tfvars -var="region_az=from var-input" -out=out.tfplan
# terraform show -json out.tfplan > output.json
# nano output.json