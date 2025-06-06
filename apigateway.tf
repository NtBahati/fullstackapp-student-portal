# API Gateway HTTP API
resource "aws_apigatewayv2_api" "student_api" {
  name          = "student-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins  = ["*"]
    allow_methods  = ["GET", "POST", "OPTIONS"]
    allow_headers  = ["*"]
    expose_headers = ["*"]
    max_age        = 3600
  }
}

# Lambda Integration for Proxy
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.student_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.student_handler.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# ANY route to catch all requests (e.g., /students, /students/data)
resource "aws_apigatewayv2_route" "proxy_any" {
  api_id    = aws_apigatewayv2_api.student_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# API Stage
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.student_api.id
  name        = "dev"
  auto_deploy = true
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.student_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
}

# API URL Output
output "api_gateway_url" {
  value = "${aws_apigatewayv2_api.student_api.api_endpoint}/${aws_apigatewayv2_stage.api_stage.name}"
}

# JS Injection for Frontend
resource "local_file" "env_js" {
  content = <<EOT
window._env_ = {
  API_URL: "${aws_apigatewayv2_api.student_api.api_endpoint}/${aws_apigatewayv2_stage.api_stage.name}"
};
EOT

  filename = "${path.module}/website/env.js"
}


# # API Gateway HTTP API
# resource "aws_apigatewayv2_api" "student_api" {
#   name          = "student-api"
#   protocol_type = "HTTP"

#   cors_configuration {
#     allow_origins  = ["*"]
#     allow_methods  = ["GET", "POST", "OPTIONS"]
#     allow_headers  = ["*"]
#     expose_headers = ["*"]
#     max_age        = 3600
#   }
# }

# # Lambda Integration for Proxy
# resource "aws_apigatewayv2_integration" "lambda_integration" {
#   api_id                 = aws_apigatewayv2_api.student_api.id
#   integration_type       = "AWS_PROXY"
#   integration_uri        = aws_lambda_function.student_handler.invoke_arn
#   integration_method     = "POST"
#   payload_format_version = "2.0"
# }

# # Routes
# resource "aws_apigatewayv2_route" "post_students" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "POST /students"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# resource "aws_apigatewayv2_route" "get_students_data" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "GET /students/data"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# resource "aws_apigatewayv2_route" "options_students" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "OPTIONS /students"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# resource "aws_apigatewayv2_route" "options_students_data" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "OPTIONS /students/data"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# # API Stage
# resource "aws_apigatewayv2_stage" "api_stage" {
#   api_id      = aws_apigatewayv2_api.student_api.id
#   name        = "dev"
#   auto_deploy = true
# }

# # Lambda Permission for API Gateway
# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.student_handler.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
# }

# # API URL Output
# output "api_gateway_url" {
#   value = "${aws_apigatewayv2_api.student_api.api_endpoint}/${aws_apigatewayv2_stage.api_stage.name}"
# }

# # JS Injection for Frontend
# resource "local_file" "env_js" {
#   content = <<EOT
# window._env_ = {
#   API_URL: "${aws_apigatewayv2_api.student_api.api_endpoint}/${aws_apigatewayv2_stage.api_stage.name}"
# };
# EOT

#   filename = "${path.module}/website/env.js"
# }



# # # Create the HTTP API Gateway with CORS
# # resource "aws_apigatewayv2_api" "student_api" {
# #   name          = "student-api"
# #   protocol_type = "HTTP"

# #   cors_configuration {
# #     allow_origins     = ["*"]  # Adjust this for security in production
# #     allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"]
# #     allow_headers     = ["*"]
# #     expose_headers    = []
# #     max_age           = 3600
# #     allow_credentials = false
# #   }
# # }

# # # Integrate Lambda with API Gateway
# # resource "aws_apigatewayv2_integration" "lambda_integration" {
# #   api_id                 = aws_apigatewayv2_api.student_api.id
# #   integration_type       = "AWS_PROXY"
# #   integration_uri        = aws_lambda_function.student_handler.invoke_arn
# #   integration_method     = "POST"
# #   payload_format_version = "2.0"
# # }

# # # Define route for GET /student
# # resource "aws_apigatewayv2_route" "get_student" {
# #   api_id    = aws_apigatewayv2_api.student_api.id
# #   route_key = "GET /student"
# #   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# # }

# # # Define route for ANY /students/{studentID}
# # resource "aws_apigatewayv2_route" "student_routes" {
# #   api_id    = aws_apigatewayv2_api.student_api.id
# #   route_key = "ANY /students/{studentID}"
# #   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# # }

# # # (Optional) Add a route for POST /student if needed
# # resource "aws_apigatewayv2_route" "create_student" {
# #   api_id    = aws_apigatewayv2_api.student_api.id
# #   route_key = "POST /student"
# #   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# # }

# # # Deploy the API
# # resource "aws_apigatewayv2_stage" "api_stage" {
# #   api_id      = aws_apigatewayv2_api.student_api.id
# #   name        = "dev"
# #   auto_deploy = true
# # }

# # # Allow API Gateway to invoke the Lambda function
# # resource "aws_lambda_permission" "apigw_lambda" {
# #   statement_id  = "AllowAPIGatewayInvoke"
# #   action        = "lambda:InvokeFunction"
# #   function_name = aws_lambda_function.student_handler.function_name
# #   principal     = "apigateway.amazonaws.com"
# #   source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
# # }
