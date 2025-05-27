# # Create the HTTP API Gateway
# resource "aws_apigatewayv2_api" "student_api" {
#   name          = "student-api"
#   protocol_type = "HTTP"
# }

# # Integrate Lambda with API Gateway
# resource "aws_apigatewayv2_integration" "lambda_integration" {
#   api_id                 = aws_apigatewayv2_api.student_api.id
#   integration_type       = "AWS_PROXY"
#   integration_uri        = aws_lambda_function.student_handler.invoke_arn
#   integration_method     = "POST"
#   payload_format_version = "2.0"
# }

# resource "aws_apigatewayv2_route" "get_student" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "GET /student"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }


# # Route for student operations
# resource "aws_apigatewayv2_route" "student_routes" {
#   api_id    = aws_apigatewayv2_api.student_api.id
#   route_key = "ANY /students/{studentID}"
#   target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# # Deploy the API
# resource "aws_apigatewayv2_stage" "api_stage" {
#   api_id      = aws_apigatewayv2_api.student_api.id
#   name        = "dev"
#   auto_deploy = true
# }

# # Allow API Gateway to invoke the Lambda
# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.student_handler.arn
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
# }
