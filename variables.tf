# General AWS Settings
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}

# S3 Website Hosting
variable "website_bucket_name" {
  description = "The name of the S3 bucket to host the website"
  type        = string
}

# DynamoDB Table
variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

# MIME Type Mappings (for file uploads)
variable "mime_types" {
  description = "Mapping of file extensions to MIME types"
  type        = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".txt"  = "text/plain"
  }
}

# CloudFront Related Variables
variable "cloudfront_comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = "CloudFront CDN for Student UI site"
}

# Tags for general use
variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "StudentPortal"
    Environment = "Dev"
  }
}
