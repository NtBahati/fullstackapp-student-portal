# Create S3 bucket
resource "aws_s3_bucket" "student_site" {
  bucket = var.website_bucket_name
  force_destroy = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "student_site_versioning" {
  bucket = aws_s3_bucket.student_site.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "student_site" {
  bucket = aws_s3_bucket.student_site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Allow public access to objects
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.student_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public read bucket policy
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.student_site.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.student_site.arn}/*"
      }
    ]
  })
}

# Upload website files from ./website
resource "aws_s3_object" "site_files" {
  for_each = fileset("./website", "**/*")

  bucket       = aws_s3_bucket.student_site.id
  key          = each.value
  source       = "./website/${each.value}"
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "text/plain")
  # acl          = "public-read"
}
