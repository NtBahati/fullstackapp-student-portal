# Creates a DynamoDB table for student data
resource "aws_dynamodb_table" "students" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "studentID"

  attribute {
    name = "studentID"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Project     = "StudentPortal"
  }
}
