# This is the main.tf file for all the configuration files for EKS and EKS Nodes


# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-eks-cluster-role"
   assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
  version = var.eks_version
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = var.subnet_id
  }

  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}

# IAM Role for EKS Worker
resource "aws_iam_role" "eks_worker" {
  name = "${var.cluster_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])

  policy_arn = each.value
  role = aws_iam_role.eks_worker.name
}

# EKS Cluster Worker Nodes
resource "aws_eks_node_group" "eks_worker_nodes" {
  for_each = var.node_groups

  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = each.key
  node_role_arn = aws_iam_role.eks_worker.arn
  subnet_ids = var.subnet_id

  instance_types = each.value.instance_types
  capacity_type = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size = each.value.scaling_config.max_size
    min_size = each.value.scaling_config.min_size
  }

  depends_on = [ aws_iam_role_policy_attachment.eks_worker_node_policy ]
}
