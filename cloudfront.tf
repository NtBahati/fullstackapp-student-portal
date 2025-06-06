resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  comment             = var.cloudfront_comment

  origin {
    domain_name = aws_s3_bucket.student_website.website_endpoint
    origin_id   = "S3WebsiteOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3WebsiteOrigin"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
  }

  tags = var.tags
}



# resource "aws_cloudfront_origin_access_control" "oac" {
#   name                              = "S3-OAC"
#   description                       = "OAC for S3 static site"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

# resource "aws_cloudfront_distribution" "cdn" {
#   enabled             = true
#   default_root_object = "index.html"

#   origin {
#     domain_name              = aws_s3_bucket.student_website.bucket_regional_domain_name
#     origin_id                = "S3Origin"
#     origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

#     s3_origin_config {
#       # Required even when using OAC — must be present, leave it empty.
#     }
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD", "OPTIONS"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = "S3Origin"
#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   price_class = "PriceClass_100"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#     minimum_protocol_version       = "TLSv1.2_2021"
#   }

#   custom_error_response {
#     error_code         = 404
#     response_code      = 404
#     response_page_path = "/error.html"
#   }

#   tags = {
#     Name = "StudentPortalCloudFront"
#   }

#   depends_on = [aws_cloudfront_origin_access_control.oac]
# }
