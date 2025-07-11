variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
}

variable "eks_version" {
  description = "value for EKS-Version"
  type = string
}

variable "vpc_id" {
  description = "value for VPC-ID"
  type = string
}

variable "subnet_id" {
  description = "value for SUBNET-ID"
  type = list(string)
}

variable "node_groups" {
  description = "value for node groups"
  type = map(object({
    instance_types = list(string)
    capacity_type = string
    scaling_config = object({
      desired_size = number
      max_size = number
      min_size = number
    })
  }))
}
