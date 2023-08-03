resource "aws_iam_role" "app-garden-of-intelligence" {
  name = "app-${var.APP_NAME}"

  assume_role_policy = data.aws_iam_policy_document.app-garden-of-intelligence-assume-role.json
}

data "aws_iam_policy_document" "app-garden-of-intelligence-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
  }

  #statement {
  #  actions  = ["rds-db:connect"]
  #  resource = "arn:aws:rds-db:eu-west-1:sandbox:dbuser:<DB_RESOURCE_ID>/<DB_USER>"
  #}
}

resource "aws_iam_role_policy_attachment" "myrolespolicy" {
  role       = aws_iam_role.app-garden-of-intelligence.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy" "ecr-garden-full-access" {
  role   = aws_iam_role.app-garden-of-intelligence.name
  name   = "ecr-${var.APP_NAME}-full-access"
  policy = data.aws_iam_policy_document.ecr-garden-full-access.json
}
