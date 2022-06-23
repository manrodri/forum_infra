# AWS
variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

# VPC
variable "vpc_id" {
  type    = string
  default = "vpc-0db0cfce7f807ebb4"
}

# gitlab
variable "gitlab_instance_type" {
  type = string
}

# forum
variable "forum_instance_type" {
  type = string
}
