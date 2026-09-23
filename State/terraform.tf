terraform {
  backend "s3" {
    bucket = "practice-terraform-state-bucket1"
    key = "finance/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "state-locking"
  }
}

resource "aws_dynamodb_table" "state-locking" {
  name = "state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}