import os, sys, json

to = sys.argv[1]
subject = sys.argv[2]
body_path = sys.argv[3]
cc_json = sys.argv[4] if len(sys.argv) > 4 else "[]"

with open(body_path) as f:
    text = f.read()

cc = json.loads(cc_json or "[]")
p = {"from": os.environ["RESEND_FROM"], "to": [to], "subject": subject, "text": text}
if os.environ.get("RESEND_REPLY_TO"):
    p["reply_to"] = os.environ["RESEND_REPLY_TO"]
if cc:
    p["cc"] = cc
with open(sys.argv[5], "w") as f:
    json.dump(p, f)
