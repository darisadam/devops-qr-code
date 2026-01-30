module "irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = "qr-code-api-role"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:qr-code-api"]
    }
  }

  role_policy_arns = {
    policy = aws_iam_policy.app_s3_access.arn
  }
}

resource "aws_iam_policy" "app_s3_access" {
  name        = "qr-code-api-s3-policy"
  description = "Allow access to the QR code application bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.app_data.arn,
          "${aws_s3_bucket.app_data.arn}/*"
        ]
      }
    ]
  })
}

output "irsa_role_arn" {
  value = module.irsa_role.iam_role_arn
}
