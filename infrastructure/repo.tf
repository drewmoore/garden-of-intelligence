data "github_repository" "this" {
  full_name = var.REPO_PATH
}

resource "github_actions_secret" "AWS_ECR_URL" {
  repository      = data.github_repository.this.name
  secret_name     = "AWS_ECR_URL"
  plaintext_value = aws_ecr_repository.garden-of-intelligence.repository_url
}

resource "github_actions_secret" "AWS_IAM_ROLE_ARN" {
  repository      = data.github_repository.this.name
  secret_name     = "AWS_IAM_ROLE_ARN"
  plaintext_value = aws_iam_role.repo.arn
}

data "aws_region" "current" {}

resource "github_actions_secret" "AWS_REGION" {
  repository      = data.github_repository.this.name
  secret_name     = "AWS_REGION"
  plaintext_value = data.aws_region.current.name
}

# Configuration for allowing github actions to communicate with AWS

# This is already setup on the shared aws account
data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "repo" {
  name = "github-actions-${var.APP_NAME}"

  assume_role_policy = data.aws_iam_policy_document.repo-assume-role.json
}

data "aws_iam_policy_document" "repo-assume-role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.REPO_PATH}:*"]
    }
  }
}

resource "aws_iam_role_policy" "repo-ecr-upload" {
  role   = aws_iam_role.repo.name
  name   = "ecr-${var.APP_NAME}-ci-upload"
  policy = data.aws_iam_policy_document.repo-ecr-upload.json
}

data "aws_iam_policy_document" "repo-ecr-upload" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:PutImage",
    ]

    resources = [aws_ecr_repository.garden-of-intelligence.arn]
  }
}
