#### Minimum example

module "minimum_cluster" {
  #checkov:skip=CKV_AWS_224:Ensure Cluster logging with CMK
  source = "../../"
  name   = var.name
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
