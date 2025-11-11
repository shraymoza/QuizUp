import os, json, boto3, tempfile
import faiss, numpy as np, pickle, io

s3 = boto3.client("s3")
smr = boto3.client("sagemaker-runtime")
BUCKET = os.environ["BUCKET"]
INDEX_PREFIX = "indexes/"
ENDPOINT = os.environ["SM_ENDPOINT"]

def _load_index():
    # download index.faiss + docstore.pkl to /tmp
    s3.download_file(BUCKET, INDEX_PREFIX + "index.faiss", "/tmp/index.faiss")
    s3obj = s3.get_object(Bucket=BUCKET, Key=INDEX_PREFIX + "docstore.pkl")
    docstore = pickle.loads(s3obj["Body"].read())
    index = faiss.read_index("/tmp/index.faiss")
    return index, docstore

def handler(event, context):
    body = json.loads(event.get("body") or "{}")
    task = body.get("task", "notes")  # "notes" | "quiz"
    query = body.get("query", "summarize the document")
    k = int(body.get("k", 5))

    index, docstore = _load_index()
    # naive embedding for the query — in real code call the same embedder as notebook and pass vector in
    # Here assume we stored per-chunk embeddings in docstore["embeddings"] and texts in docstore["texts"]
    # For demo, just take top-k from saved metadata:
    D, I = index.search(np.array([docstore["query_embedder"](query)]).astype("float32"), k)
    context_chunks = "\n\n".join([docstore["texts"][i] for i in I[0]])

    prompt = f"Generate {'concise study notes' if task=='notes' else 'a 5-question MCQ quiz with answer key'} from:\n{context_chunks}\n"

    resp = smr.invoke_endpoint(
        EndpointName=ENDPOINT,
        ContentType="application/json",
        Body=json.dumps({"inputs": prompt})
    )
    out = json.loads(resp["Body"].read())

    result_text = out[0]["generated_text"] if isinstance(out, list) and "generated_text" in out[0] else str(out)
    key = f"outputs/result-{int(context.aws_request_id[-6:],16)}.txt"
    s3.put_object(Bucket=BUCKET, Key=key, Body=result_text.encode("utf-8"))

    return {"statusCode": 200, "headers": {"Content-Type":"application/json"},
            "body": json.dumps({"result": result_text, "s3_key": key})}
