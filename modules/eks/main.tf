resource "aws_eks_cluster" "eks" {
  name     = "${var.resource_prefix}-${var.cluster_suffix}"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_role_arn   = var.node_role_arn
  subnets         = var.subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  # Autoscaling based on CPU
  auto_scaling_group {
    metrics_collection {
      granularity = "1Minute"
    }
  }
}


