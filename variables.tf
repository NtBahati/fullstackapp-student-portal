# Defines reusable variables.
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}


variable "website_bucket_name" {
  description = "The name of the S3 bucket to host the website"
  type        = string
}

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
