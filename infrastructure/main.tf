# conigure AWS APP Runner
resource "aws_apprunner_service" "garden_of_intelligence" {
  service_name = "garden-of-intelligence"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app-garden-of-intelligence.arn
    }
    image_repository {
      image_configuration {
        port = "3000" #The port that your application listens to in the container                             
      }
      image_identifier = "${aws_ecr_repository.garden-of-intelligence.repository_url}:latest"                          
      image_repository_type = "ECR"
    }

  }
}

output "service_url" {
  value = aws_apprunner_service.garden_of_intelligence.service_url
}