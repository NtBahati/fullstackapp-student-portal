# DEVOPS EASY LEARNING PROJECT DEMO


## Student Registration Portal - Serverless AWS Project

## 📚 Overview

This project demonstrates how to build a fully serverless student registration and information retrieval portal using AWS services. Users can register and fetch student details through a frontend website connected to a backend API powered by AWS Lambda and DynamoDB.

This project integrates modern AWS cloud services including:

- **S3** (Static website hosting)
- **CloudFront** (CDN and HTTPS)
- **API Gateway** (API management)
- **Lambda** (Backend logic)
- **DynamoDB** (Data storage)
- **KMS** (Data encryption)

---

## 📦 Project Architecture

```
[CloudFront + S3 (Website Frontend)] → [API Gateway] → [Lambda Function] → [DynamoDB]
                                              ↘
                                           [KMS Encryption (optional)]
```

---

## 🚀 Features

- Student registration form (HTML + CSS + Bootstrap)
- API Gateway REST API endpoints (POST and GET)
- Lambda function to store and retrieve students
- CORS enabled for cross-domain communication
- DynamoDB backend storage
- CloudFront for frontend delivery
- Optional Route 53 and KMS integration for advanced scenarios

---

## 🛠️ Deployment Steps

### 1. DynamoDB

- Create table `Students` with primary key `studentID`

### 2. Lambda

- Create function and IAM role with DynamoDB permissions
- Add CORS headers to all Lambda responses

### 3. API Gateway

- Create REST API
- Create resources and methods `/students` (POST) and `/students/{studentID}` (GET)
- Enable CORS on each method
- Deploy API

### 4. Frontend

- Upload `index.html` and images to S3 bucket with static website hosting enabled
- Create CloudFront distribution pointing to S3 bucket
- Configure default root object `index.html`

### 5. (Optional Bonus)

- Configure Route 53 custom domain
- Create KMS Key and enable rotation

### 6. Testing

- Visit CloudFront domain
- Register students
- Retrieve students
- Check DynamoDB for entries

---

## 🧹 Troubleshooting

**CORS Issues**

- Ensure API Gateway has OPTIONS method with CORS enabled
- Add `Access-Control-Allow-Origin` header in Lambda responses

**API not working / 404 errors**

- Verify resource paths and method integration
- Check API Gateway stage deployment

**Frontend not updating**

- Invalidate CloudFront cache
- Clear browser cache

**Lambda not triggering or logging**

- Check permissions and CloudWatch logs

---

## 📌 Best Practices (For Production)

- Lock CORS `Access-Control-Allow-Origin` to specific CloudFront domain (not `*`)
- Enable KMS encryption on DynamoDB (optional)
- Use Route 53 for a custom domain and better branding
- Implement input validation and security headers

---

## 📢 Credits and Usage

This project was built for educational purposes to demonstrate AWS serverless web architectures. It can be extended and customized for real-world projects.
