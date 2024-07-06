resource "aws_s3_bucket" "s3b" {
  bucket = "sai-s3-97"
  acl    = "private"

  tags = {
    Name        = "bucket1"
    Environment = "Dev"
  }
}
