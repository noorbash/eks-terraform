output "cluster_sg" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "node_group_asg" {
  value = aws_eks_node_group.node_group.resources.0.autoscaling_groups[0].name
}