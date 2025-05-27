# # Packages the Lambda function.
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "./lambda"
#   output_path = "./lambda.zip"
# }

# # IAM role for Lambda to assume.
# resource "aws_iam_role" "lambda_exec" {
#   name = "lambda_exec_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement: [
#       {
#         Action: "sts:AssumeRole",
#         Principal: {
#           Service: "lambda.amazonaws.com"
#         },
#         Effect: "Allow",
#         Sid: ""
#       }
#     ]
#   })
# }


# # IAM policy for Lambda to use DynamoDB and CloudWatch.
# resource "aws_iam_policy" "lambda_policy" {
#   name = "lambda_policy"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "arn:aws:logs:*:*:*"
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "dynamodb:PutItem",
#           "dynamodb:GetItem"
#         ],
#         Resource = aws_dynamodb_table.students.arn
#       }
#     ]
#   })
# }

# # Attach the policy to the role.
# resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = aws_iam_policy.lambda_policy.arn
# }

# # Create the Lambda function.
# resource "aws_lambda_function" "student_handler" {
#   filename         = data.archive_file.lambda_zip.output_path
#   function_name    = "studentHandler"
#   role             = aws_iam_role.lambda_exec.arn
#   handler          = "function.lambda_handler"
#   runtime          = "python3.9"
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256
# }

# # # Allow API Gateway to invoke the Lambda function
# # resource "aws_lambda_permission" "apigw_lambda" {
# #   statement_id  = "AllowAPIGatewayInvoke"
# #   action        = "lambda:InvokeFunction"
# #   function_name = aws_lambda_function.student_handler.function_name
# #   principal     = "apigateway.amazonaws.com"
# #   source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
# # }