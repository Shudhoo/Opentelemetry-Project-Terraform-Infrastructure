output "eks_endpoint" {
  description = "value for EKS-Endpoint"
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  description = "value for EKS-CLUSTER"
  value = aws_eks_cluster.eks_cluster.name
}