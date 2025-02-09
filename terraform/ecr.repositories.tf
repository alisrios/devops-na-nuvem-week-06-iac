resource "aws_ecr_repository" "this" {
  count = length(var.repositories)

  force_delete         = true
  name                 = var.repositories[count.index].name
  image_tag_mutability = var.repositories[count.index].image_tag_mutability
}
