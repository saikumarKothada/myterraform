resource "aws_s3_bucket" "s3b" {
  bucket = "sai-s3-97"
  aws_s3_bucket_acl = "private"

  tags = {
    Name        = "bucket1"
    Environment = "Dev"
  }
}
