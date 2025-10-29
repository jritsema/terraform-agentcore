import json
import argparse
import uuid
import boto3

# accept agent runtime arn as cli argument
parser = argparse.ArgumentParser()
parser.add_argument("--agent-runtime-arn",
                    help="Agent Runtime ARN", required=True)
parser.add_argument("--prompt",
                    help="User prompt", required=True)
args = parser.parse_args()

client = boto3.client("bedrock-agentcore")
payload = json.dumps({
    "input": {
        "prompt": args.prompt,
        "user_id": "123",
    }
})

session_id = str(uuid.uuid4())
print(f'sending prompt: "{args.prompt}" to {args.agent_runtime_arn} using session {session_id}')

response = client.invoke_agent_runtime(
    agentRuntimeArn=args.agent_runtime_arn,
    runtimeSessionId=session_id,
    payload=payload,
)

for line in response['response'].iter_lines():
    if line:
        line_str = line.decode('utf-8')
        if line_str.startswith("data: "):
            print(line_str[6:], end="", flush=True)
