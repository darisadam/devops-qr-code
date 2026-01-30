resource "aws_ecr_repository" "api" {
  name                 = "qr-code-api"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "qr-code-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_api_url" {
  value = aws_ecr_repository.api.repository_url
}

output "ecr_repository_frontend_url" {
  value = aws_ecr_repository.frontend.repository_url
}
