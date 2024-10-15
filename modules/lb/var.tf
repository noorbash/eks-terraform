variable "security_group_ids" {
  description = "A list of security group IDs to associate with the resources."
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the resources will be launched."
  type        = list(string)
}
