#### Minimum example

resource "random_id" "minimum_suffix" {
  byte_length = 3
}

module "minimum_cluster" {
  #checkov:skip=CKV_AWS_224:Ensure Cluster logging with CMK
  source = "../../"
  name   = "${var.name}-${random_id.minimum_suffix.hex}"
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
