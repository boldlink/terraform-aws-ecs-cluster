
output "arn" {
  description = "ARN that identifies the cluster."
  value       = aws_ecs_cluster.this.arn
}

output "id" {
  description = "ARN that identifies the cluster."
  value       = aws_ecs_cluster.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags"
  value       = aws_ecs_cluster.this.tags_all
}
