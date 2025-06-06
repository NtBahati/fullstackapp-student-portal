output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static website"
  value       = aws_s3_bucket.student_website.id
}


output "s3_website_endpoint" {
  value       = "http://${aws_s3_bucket.student_website.bucket_regional_domain_name}"
  description = "Website endpoint for the S3 static site"
}

# output "s3_website_endpoint" {
#   value = aws_s3_bucket.student_website.website_endpoint
# }

output "cloudfront_distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.student_handler.function_name
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = aws_lambda_function.student_handler.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.students.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.students.arn
}

output "lambda_execution_role_arn" {
  description = "ARN of the IAM role assumed by Lambda"
  value       = aws_iam_role.lambda_exec_role.arn
}

