import os, json, boto3, time
s3 = boto3.client("s3")
BUCKET = os.environ["BUCKET"]

def handler(event, context):
    # expect ?filename=… (or body JSON)
    q = event.get("queryStringParameters") or {}
    filename = q.get("filename", f"upload-{int(time.time())}.pdf")
    key = f"raw/{filename}"
    url = s3.generate_presigned_url(
        ClientMethod="put_object",
        Params={"Bucket": BUCKET, "Key": key, "ContentType": "application/pdf"},
        ExpiresIn=600
    )
    return {"statusCode": 200, "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"upload_url": url, "s3_key": key})}
