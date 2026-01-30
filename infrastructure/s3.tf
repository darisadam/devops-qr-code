resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app_data" {
  bucket = "qr-code-app-data-${random_id.bucket_suffix.hex}"
  force_delete = true # For easier cleanup in this demo project
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "app_bucket_name" {
  value = aws_s3_bucket.app_data.id
}
