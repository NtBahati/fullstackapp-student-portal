resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBAccess"
  description = "Allow Lambda to access DynamoDB Students table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.students.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_dynamodb" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_lambda_function" "student_handler" {
  function_name = "student-handler"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/lambda/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/lambda_function.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.students.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.basic_exec,
    aws_iam_role_policy_attachment.lambda_attach_dynamodb
  ]
}



# # Package the Lambda function
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "./lambda"
#   output_path = "./lambda.zip"
# }

# # IAM role for Lambda execution
# resource "aws_iam_role" "lambda_exec" {
#   name = "lambda_exec_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement : [
#       {
#         Action = "sts:AssumeRole",
#         Principal : {
#           Service : "lambda.amazonaws.com"
#         },
#         Effect = "Allow",
#         Sid    = ""
#       }
#     ]
#   })
# }

# # Attach required policies
# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_iam_role_policy_attachment" "lambda_full_access" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
# }

# resource "aws_iam_role_policy_attachment" "sns_full_access" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
# }

# # S3 Bucket (define it once here!)
# resource "aws_s3_bucket" "student_website" {
#   bucket = "my-unique-student-site-bucket" # Change this to a globally unique name
# }

# # Lambda function definition (Node.js)
# resource "aws_lambda_function" "student_handler" {
#   filename         = data.archive_file.lambda_zip.output_path
#   function_name    = "studentHandler"
#   role             = aws_iam_role.lambda_exec.arn
#   handler          = "index.handler"
#   runtime          = "nodejs18.x"
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256

#   environment {
#     variables = {
#       STUDENTS_TABLE = "Students"
#     }
#   }
# }

# # Lambda invoke permission for S3
# resource "aws_lambda_permission" "allow_s3_trigger" {
#   statement_id  = "AllowS3InvokeLambda"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.student_handler.function_name
#   principal     = "s3.amazonaws.com"
#   source_arn    = aws_s3_bucket.student_website.arn
# }

# # S3 bucket notification to trigger Lambda
# resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
#   bucket = aws_s3_bucket.student_website.id

#   lambda_function {
#     lambda_function_arn = aws_lambda_function.student_handler.arn
#     events              = ["s3:ObjectCreated:*"]
#   }

#   depends_on = [aws_lambda_permission.allow_s3_trigger]
# }

# # # Package the Lambda function
# # data "archive_file" "lambda_zip" {
# #   type        = "zip"
# #   source_dir  = "./lambda"
# #   output_path = "./lambda.zip"
# # }

# # # IAM role for Lambda execution
# # resource "aws_iam_role" "lambda_exec" {
# #   name = "lambda_exec_role"

# #   assume_role_policy = jsonencode({
# #     Version = "2012-10-17",
# #     Statement: [
# #       {
# #         Action = "sts:AssumeRole",
# #         Principal: {
# #           Service: "lambda.amazonaws.com"
# #         },
# #         Effect = "Allow",
# #         Sid    = ""
# #       }
# #     ]
# #   })
# # }

# # # Attach required policies
# # resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
# #   role       = aws_iam_role.lambda_exec.name
# #   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# # }

# # resource "aws_iam_role_policy_attachment" "lambda_full_access" {
# #   role       = aws_iam_role.lambda_exec.name
# #   policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
# # }

# # resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
# #   role       = aws_iam_role.lambda_exec.name
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
# # }

# # resource "aws_iam_role_policy_attachment" "sns_full_access" {
# #   role       = aws_iam_role.lambda_exec.name
# #   policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
# # }

# # # Lambda function definition
# # resource "aws_lambda_function" "student_handler" {
# #   filename         = data.archive_file.lambda_zip.output_path
# #   function_name    = "studentHandler"
# #   role             = aws_iam_role.lambda_exec.arn
# #   handler          = "function.lambda_handler"
# #   runtime          = "python3.9"
# #   source_code_hash = data.archive_file.lambda_zip.output_base64sha256

# #   environment {
# #     variables = {
# #       STUDENTS_TABLE = "Students"
# #     }
# #   }
# # }

# # # Permission for S3 to invoke Lambda
# # resource "aws_lambda_permission" "allow_s3_trigger" {
# #   statement_id  = "AllowS3InvokeLambda"
# #   action        = "lambda:InvokeFunction"
# #   function_name = aws_lambda_function.student_handler.function_name
# #   principal     = "s3.amazonaws.com"
# #   source_arn    = aws_s3_bucket.student_site.arn
# # }

# # # S3 bucket notification for Lambda invocation on object created events
# # resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
# #   bucket = aws_s3_bucket.student_site.id

# #   lambda_function {
# #     lambda_function_arn = aws_lambda_function.student_handler.arn
# #     events              = ["s3:ObjectCreated:*"]
# #   }

# #   depends_on = [aws_lambda_permission.allow_s3_trigger]
# # }


# #  # Packages the Lambda function.
# # # data "archive_file" "lambda_zip" {
# # #   type        = "zip"
# # #   source_dir  = "./lambda"
# # #   output_path = "./lambda.zip"
# # # }

# # # # IAM role for Lambda to assume.
# # # resource "aws_iam_role" "lambda_exec" {
# # #   name = "lambda_exec_role"

# # #   assume_role_policy = jsonencode({
# # #     Version = "2012-10-17",
# # #     Statement: [
# # #       {
# # #         Action = "sts:AssumeRole",
# # #         Principal: {
# # #           Service: "lambda.amazonaws.com"
# # #         },
# # #         Effect = "Allow",
# # #         Sid = ""
# # #       }
# # #     ]
# # #   })
# # # }

# # # # Attach managed policies to the role
# # # resource "aws_iam_role_policy_attachment" "lambda_full_access" {
# # #   role       = aws_iam_role.lambda_exec.name
# # #   policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
# # # }

# # # resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
# # #   role       = aws_iam_role.lambda_exec.name
# # #   policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
# # # }

# # # resource "aws_iam_role_policy_attachment" "sns_full_access" {
# # #   role       = aws_iam_role.lambda_exec.name
# # #   policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
# # # }

# # # resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
# # #   role       = aws_iam_role.lambda_exec.name
# # #   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# # # }

# # # # Create the Lambda function.
# # # resource "aws_lambda_function" "student_handler" {
# # #   filename         = data.archive_file.lambda_zip.output_path
# # #   function_name    = "studentHandler"
# # #   role             = aws_iam_role.lambda_exec.arn
# # #   handler          = "function.lambda_handler"
# # #   runtime          = "python3.9"
# # #   source_code_hash = data.archive_file.lambda_zip.output_base64sha256
# # # }

# # # # # Allow API Gateway to invoke the Lambda function
# # # # resource "aws_lambda_permission" "apigw_lambda" {
# # # #   statement_id  = "AllowAPIGatewayInvoke"
# # # #   action        = "lambda:InvokeFunction"
# # # #   function_name = aws_lambda_function.student_handler.function_name
# # # #   principal     = "apigateway.amazonaws.com"
# # # #   source_arn    = "${aws_apigatewayv2_api.student_api.execution_arn}/*/*"
# # # # }
