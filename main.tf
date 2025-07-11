# This is where all the modules to create EKS Cluster are called !!

module "vpc" {
  source = "./eks-modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./eks-modules/eks-cluster"
  eks_version = var.eks_version
  vpc_id = module.vpc.vpc_id
  cluster_name = var.cluster_name
  subnet_id = module.vpc.private_subnet_id
  node_groups = var.node_groups
}