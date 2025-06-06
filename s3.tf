# Create S3 bucket
resource "aws_s3_bucket" "student_website" {
  bucket        = var.website_bucket_name
  force_destroy = true

  tags = var.tags
}

# Disable blocking of public access to allow the site to be publicly reachable
resource "aws_s3_bucket_public_access_block" "disable_block" {
  bucket = aws_s3_bucket.student_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.student_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Allow public read access to the bucket
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.student_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.student_website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.disable_block]
}

# List all files in the website folder
locals {
  website_files = fileset("${path.module}/website", "**/*.*")
}

# Upload website files dynamically with proper MIME types
resource "aws_s3_object" "website_assets" {
  for_each = { for file in local.website_files : file => file }

  bucket = aws_s3_bucket.student_website.id
  key    = each.key
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")

  content_type = lookup(
    var.mime_types,
    regex("\\.[^.]+$", each.value),
    "application/octet-stream"
  )
}



# resource "aws_s3_bucket_versioning" "student_site_versioning" {
#   bucket = aws_s3_bucket.student_website.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_website_configuration" "web" {
#   bucket = aws_s3_bucket.student_website.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access" {
#   bucket                  = aws_s3_bucket.student_website.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_policy" "website_policy" {
#   bucket     = aws_s3_bucket.student_website.id
#   depends_on = [aws_s3_bucket_public_access_block.public_access]

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject",
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = "s3:GetObject",
#         Resource  = "${aws_s3_bucket.student_website.arn}/*"
#       }
#     ]
#   })
# }

# resource "aws_s3_object" "site_files" {
#   for_each = fileset("${path.module}/website", "**")

#   bucket       = aws_s3_bucket.student_website.id
#   key          = each.value
#   source       = "${path.module}/website/${each.value}"
#   etag         = filemd5("${path.module}/website/${each.value}")
#   content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
# }

# resource "aws_s3_bucket" "student_website" {
#   bucket = var.website_bucket_name

#   tags = {
#     Environment = "dev"
#     Project     = "StudentPortal"
#   }
# }


# # resource "aws_s3_bucket_versioning" "student_site_versioning" {
# #   bucket = aws_s3_bucket.student_website.id

# #   versioning_configuration {
# #     status = "Enabled"
# #   }
# # }

# # resource "aws_s3_bucket_website_configuration" "web" {
# #   bucket = aws_s3_bucket.student_website.id

# #   index_document {
# #     suffix = "index.html"
# #   }

# #   error_document {
# #     key = "error.html"
# #   }
# # }

# # resource "aws_s3_bucket_public_access_block" "public_access" {
# #   bucket                  = aws_s3_bucket.student_website.id
# #   block_public_acls       = false
# #   block_public_policy     = false
# #   ignore_public_acls      = false
# #   restrict_public_buckets = false
# # }

# # resource "aws_s3_bucket_policy" "website_policy" {
# #   bucket     = aws_s3_bucket.student_website.id
# #   depends_on = [aws_s3_bucket_public_access_block.public_access]

# #   policy = jsonencode({
# #     Version = "2012-10-17",
# #     Statement = [
# #       {
# #         Sid       = "PublicReadGetObject",
# #         Effect    = "Allow",
# #         Principal = "*",
# #         Action    = "s3:GetObject",
# #         Resource  = "${aws_s3_bucket.student_website.arn}/*"
# #       }
# #     ]
# #   })
# # }

# # # resource "aws_s3_object" "site_files" {
# # #   for_each = fileset("./website", "**/*")

# # #   bucket       = aws_s3_bucket.student_website.id
# # #   key          = each.value
# # #   source       = "./website/${each.value}"
# # #   content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "text/plain")
# # # }

# # resource "aws_s3_object" "site_files" {
# #   for_each = fileset("${path.module}/website", "**")

# #   bucket       = aws_s3_bucket.student_website.id
# #   key          = each.value
# #   source       = "${path.module}/website/${each.value}"
# #   etag         = filemd5("${path.module}/website/${each.value}")
# #   content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
# # }
