# This variables for VPC
variable "vpc_cidr" {
  description = "value for VPC-CIDR-BLOCK"
  type = string
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
  default = "opentelemetry-eks-cluster"
}

variable "private_subnet_cidrs" {
  description = "value for PRIVATE-SUBNET-CIDR"
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "value for AVAILABILITY-ZONE"
  type = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "public_subnet_cidrs" {
  description = "value for PUBLIC-SUBNET-CIDR"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


# This varaibles for  EKS-Cluster

variable "eks_version" {
  description = "value for EKS-Version"
  type = string
  default = "1.30"
}

variable "node_groups" {
  description = "value for node groups configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type = string
    scaling_config = object({
      desired_size = number
      max_size = number
      min_size = number
    })
  }))
  default = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
    }
  }
}