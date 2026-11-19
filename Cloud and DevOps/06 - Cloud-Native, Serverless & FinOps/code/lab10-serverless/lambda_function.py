import json
import logging
import datetime
import uuid

# Configure structured logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# In-memory mock database
ITEMS_DB = [
    {"id": "1", "name": "Terraform Up & Running", "category": "IaC"},
    {"id": "2", "name": "Site Reliability Engineering", "category": "DevOps"},
    {"id": "3", "name": "Designing Data-Intensive Applications", "category": "Architecture"}
]

def lambda_handler(event, context):
    request_id = context.aws_request_id if context else str(uuid.uuid4())
    logger.info(f"Incoming request {request_id}: {json.dumps(event)}")

    # Extract HTTP routing info (API Gateway v2 HTTP payload)
    http_method = event.get("requestContext", {}).get("http", {}).get("method", "GET")
    raw_path = event.get("rawPath", "/items")

    # Routing logic
    if raw_path == "/health":
        return build_response(200, {
            "status": "healthy",
            "timestamp": datetime.datetime.utcnow().isoformat() + "Z"
        })

    elif raw_path == "/items" and http_method == "GET":
        return build_response(200, {
            "items": ITEMS_DB,
            "count": len(ITEMS_DB),
            "requestId": request_id
        })

    elif raw_path == "/items" and http_method == "POST":
        body = {}
        if "body" in event and event["body"]:
            try:
                body = json.loads(event["body"])
            except Exception:
                return build_response(400, {"error": "Invalid JSON body"})
        
        new_item = {
            "id": str(len(ITEMS_DB) + 1),
            "name": body.get("name", "Untitled Item"),
            "category": body.get("category", "General")
        }
        ITEMS_DB.append(new_item)
        logger.info(f"Created new item: {new_item}")
        return build_response(201, {"created": new_item, "requestId": request_id})

    else:
        return build_response(404, {"error": "Resource Not Found", "path": raw_path})

def build_response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET,POST,OPTIONS"
        },
        "body": json.dumps(body)
    }
