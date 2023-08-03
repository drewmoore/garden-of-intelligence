data "github_repository" "this" {
  full_name = var.REPO_PATH
}

resource "github_actions_secret" "AWS_ECR_URL" {
  repository      = data.github_repository.this.name
  secret_name     = "AWS_ECR_URL"
  plaintext_value = aws_ecr_repository.garden-of-intelligence.repository_url
}

resource "github_actions_secret" "AWS_IAM_ROLE_ARN" {
  repository  = data.github_repository.this.name
  secret_name = "AWS_IAM_ROLE_ARN"
  # TODO: use separate role for ci
  plaintext_value = aws_iam_role.app-garden-of-intelligence.arn
}

data "aws_region" "current" {}

resource "github_actions_secret" "AWS_REGION" {
  repository      = data.github_repository.this.name
  secret_name     = "AWS_REGION"
  plaintext_value = data.aws_region.current.name
}
