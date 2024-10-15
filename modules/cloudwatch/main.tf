resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_actions       = [module.eks.node_group_asg]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group
  }
}
