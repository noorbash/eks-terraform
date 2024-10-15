variable "vpc_id" {
  description = "VPC ID for the existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for EKS and other resources"
  type        = list(string)
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
}