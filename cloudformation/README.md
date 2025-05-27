**CloudFormation Template!**
***This will deploy:***

- DynamoDB (Students table)

- KMS Key (with rotation)

- S3 (frontend hosting bucket + policy)

- Lambda (Python + CORS + DynamoDB access)

- API Gateway (REST → Lambda integration with CORS)

- CloudFront (for student portal site)