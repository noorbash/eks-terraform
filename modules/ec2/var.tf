variable "instance_type" {
  description = "The instance type to use for the EC2 instance."
  type        = string
  default     = "t2.micro"  # Optionally set a default value
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access."
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in."
  type        = string
}
