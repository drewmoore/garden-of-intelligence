resource "github_actions_secret" "AWS_ECR_URL" {
  repository       = var.REPO_PATH
  secret_name      = "AWS_ECR_URL"
  plaintext_value  = aws_ecr_repository.garden-of-intelligence.repository_url
}

resource "github_actions_secret" "AWS_IAM_ROLE_ARN" {
  repository       = var.REPO_PATH
  secret_name      = "AWS_IAM_ROLE_ARN"
  plaintext_value  = aws_iam_role.app-garden-of-intelligence.arn
}

data "aws_region" "current" {}

resource "github_actions_secret" "AWS_REGION" {
  repository       = var.REPO_PATH
  secret_name      = "AWS_REGION"
  plaintext_value  = data.aws_region.current.name
}
