import json
import boto3
import os
import logging

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB table
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ.get("DYNAMODB_TABLE"))

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))

    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,GET,POST,PUT,DELETE",
        "Access-Control-Allow-Headers": "Content-Type"
    }

    try:
        method = event.get("requestContext", {}).get("http", {}).get("method") or event.get("httpMethod")
        path = event.get("rawPath") or event.get("path", "")
        body = json.loads(event.get("body", "{}")) if event.get("body") else {}
        

        # Strip stage prefix if it exists (e.g., /dev/students → /students)
        stage = event.get("requestContext", {}).get("stage", "")
        if path.startswith(f"/{stage}"):
            path = path[len(f"/{stage}"):]
        

        # Handle CORS preflight
        if method == "OPTIONS":
            return {
                "statusCode": 200,
                "headers": headers,
                "body": json.dumps({"message": "CORS preflight successful"})
            }

        # POST /students – Register new student
        if method == "POST" and path == "/students":
            studentID = body.get("studentID")
            if not studentID:
                return _error_response(400, headers, "Missing required field: studentID")

            table.put_item(Item=body)
            return _success_response(201, headers, {"message": "Student registered successfully"})

        # Routes for /students/{studentID}
        if path.startswith("/students/"):
            studentID = path.split("/")[-1]
            if not studentID:
                return _error_response(400, headers, "Missing student ID in path")

            if method == "GET":
                response = table.get_item(Key={"studentID": studentID})
                item = response.get("Item")
                if not item:
                    return _error_response(404, headers, "Student not found")
                return _success_response(200, headers, item)

            elif method == "PUT":
                if not body:
                    return _error_response(400, headers, "Request body required for update")
                body["studentID"] = studentID
                table.put_item(Item=body)
                return _success_response(200, headers, {"message": "Student updated successfully"})

            elif method == "DELETE":
                table.delete_item(Key={"studentID": studentID})
                return _success_response(200, headers, {"message": "Student deleted successfully"})

        # Fallback
        return _error_response(404, headers, f"Unsupported method/path: {method} {path}")

    except Exception as e:
        logger.error("Unhandled exception: %s", str(e), exc_info=True)
        return _error_response(500, headers, "Internal server error", details=str(e))

# Success response helper
def _success_response(status, headers, body):
    return {
        "statusCode": status,
        "headers": headers,
        "body": json.dumps(body)
    }

# Error response helper
def _error_response(status, headers, message, details=None):
    error = {"error": message}
    if details:
        error["details"] = details
    return {
        "statusCode": status,
        "headers": headers,
        "body": json.dumps(error)
    }



# import json
# import boto3
# import os
# import logging

# from boto3.dynamodb.conditions import Key

# # Setup logging
# logger = logging.getLogger()
# logger.setLevel(logging.INFO)

# # Load DynamoDB table from environment variable
# dynamodb = boto3.resource('dynamodb')
# table = dynamodb.Table(os.environ['STUDENTS_TABLE'])

# def lambda_handler(event, context):
#     try:
#         method = event['requestContext']['http']['method']
#         path = event['rawPath']

#         headers = {
#             "Access-Control-Allow-Origin": "*",
#             "Access-Control-Allow-Methods": "OPTIONS,GET,POST",
#             "Access-Control-Allow-Headers": "Content-Type"
#         }

#         # Handle CORS preflight
#         if method == "OPTIONS":
#             return {
#                 "statusCode": 200,
#                 "headers": headers,
#                 "body": json.dumps({"message": "CORS preflight OK"})
#             }

#         # POST /students - Register student
#         if method == "POST" and path == "/students":
#             body = json.loads(event.get("body", "{}"))

#             studentID = body.get("studentID")
#             if not studentID:
#                 return {
#                     "statusCode": 400,
#                     "headers": headers,
#                     "body": json.dumps({"error": "Student ID is required."})
#                 }

#             # Optional: validate other fields like name, email, department

#             # Insert into DynamoDB
#             table.put_item(Item=body)

#             return {
#                 "statusCode": 200,
#                 "headers": headers,
#                 "body": json.dumps({"message": "Student registered successfully."})
#             }

#         # GET /students/{studentID}
#         if method == "GET" and path.startswith("/students/"):
#             studentID = path.split("/")[-1]
#             if not studentID:
#                 return {
#                     "statusCode": 400,
#                     "headers": headers,
#                     "body": json.dumps({"error": "Missing student ID in path."})
#                 }

#             response = table.get_item(Key={"studentID": studentID})

#             if "Item" not in response:
#                 return {
#                     "statusCode": 404,
#                     "headers": headers,
#                     "body": json.dumps({"message": "Student not found."})
#                 }

#             return {
#                 "statusCode": 200,
#                 "headers": headers,
#                 "body": json.dumps(response["Item"])
#             }

#         # Default response for unsupported paths
#         return {
#             "statusCode": 404,
#             "headers": headers,
#             "body": json.dumps({"error": "Route not found"})
#         }

#     except Exception as e:
#         logger.error(f"Error occurred: {str(e)}", exc_info=True)
#         return {
#             "statusCode": 500,
#             "headers": {
#                 "Access-Control-Allow-Origin": "*"
#             },
#             "body": json.dumps({"error": "Internal server error", "details": str(e)})
#         }

# import json
# import boto3
# from boto3.dynamodb.conditions import Key

# dynamodb = boto3.resource('dynamodb')
# table = dynamodb.Table('Students')

# def lambda_handler(event, context):
#     method = event['httpMethod']

#     if method == "POST":
#         body = json.loads(event['body'])
#         table.put_item(Item=body)
#         return {
#             "statusCode": 200,
#             "headers": {
#                 "Access-Control-Allow-Origin": "*"
#             },
#             "body": json.dumps("Student registered successfully")
#         }

#     elif method == "GET":
#         student_id = event['pathParameters']['studentID']
#         response = table.get_item(Key={'studentID': student_id})
#         item = response.get('Item')
#         if item:
#             return {
#                 "statusCode": 200,
#                 "headers": {
#                     "Access-Control-Allow-Origin": "*"
#                 },
#                 "body": json.dumps(item)
#             }
#         else:
#             return {
#                 "statusCode": 404,
#                 "headers": {
#                     "Access-Control-Allow-Origin": "*"
#                 },
#                 "body": json.dumps("Student not found")
#             }

#     return {
#         "statusCode": 400,
#         "headers": {
#             "Access-Control-Allow-Origin": "*"
#         },
#         "body": json.dumps("Unsupported method")
#     }
