# ---------------------------------------------------------------------------------------------------------------------
# APPRUNNER
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_apprunner_service" "garden_of_intelligence" {
  service_name = var.APP_NAME

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app-garden-of-intelligence.arn
    }
    image_repository {
      image_configuration {
        port = "3000" #The port that your application listens to in the container
        runtime_environment_variables = {
          ENVIRONMENT = "production"
          RAILS_ENV   = "production"
          DATABSE_URL = aws_db_instance.db.endpoint
        }
      }
      image_identifier      = "${aws_ecr_repository.garden-of-intelligence.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }
  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.APP_NAME}_vpc_connector"
  subnets            = aws_subnet.private[*].id
  security_groups    = [aws_security_group.db-sg.id]
}

output "service_url" {
  value = aws_apprunner_service.garden_of_intelligence.service_url
}
