# Configure the AWS ECR
resource "aws_ecr_repository" "garden-of-intelligence" {
  name                 = var.APP_NAME
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_iam_policy_document" "ecr-garden-full-access" {
  statement {
    actions   = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]

    resources = [aws_ecr_repository.garden-of-intelligence.arn]
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.garden-of-intelligence.repository_url
}
