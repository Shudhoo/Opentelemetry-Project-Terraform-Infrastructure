variable "vpc_cidr" {
  description = "value for VPC-CIDR-BLOCK"
  type = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
}

variable "private_subnet_cidrs" {
  description = "value for PRIVATE-SUBNET-CIDR"
  type = list(string)
}

variable "availability_zones" {
  description = "value for AVAILABILITY-ZONE"
  type = list(string)
}

variable "public_subnet_cidrs" {
  description = "value for PUBLIC-SUBNET-CIDR"
  type = list(string)
}