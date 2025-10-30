import json
import argparse
import uuid
import boto3
from botocore.config import Config
import time

# Colors and emojis
class Colors:
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_banner():
    print(f"\n{Colors.PURPLE}{Colors.BOLD}{'='*60}")
    print("🚀 AMAZON BEDROCK AGENTCORE TEST CLIENT 🚀")
    print(f"{'='*60}{Colors.END}\n")

def print_section(title, content, color=Colors.CYAN):
    print(f"{color}{Colors.BOLD}🔹 {title}:{Colors.END}")
    print(f"   {content}\n")

# accept agent runtime arn as cli argument
parser = argparse.ArgumentParser()
parser.add_argument("--agent-runtime-arn",
                    help="Agent Runtime ARN", required=True)
parser.add_argument("--prompt",
                    help="User prompt", required=True)
args = parser.parse_args()

print_banner()

# Configure client with increased timeout
config = Config(
    read_timeout=600,  # 5 minutes
    connect_timeout=60,  # 1 minute
    retries={'max_attempts': 3}
)

client = boto3.client("bedrock-agentcore", config=config)
user_id = "123"
payload = json.dumps({
    "input": {
        "prompt": args.prompt,
        "user_id": user_id,
    }
})

session_id = str(uuid.uuid4())

print_section("AgentCore Runtime", args.agent_runtime_arn.split('/')[-1], Colors.GREEN)
print_section("User ID", user_id, Colors.PURPLE)
print_section("Session ID", session_id, Colors.YELLOW)
print_section("User Prompt", f'"{args.prompt}"', Colors.CYAN)

print(f"{Colors.PURPLE}{Colors.BOLD}🤖 Agent Response (streaming):{Colors.END}")
print(f"{Colors.GREEN}{'─'*50}{Colors.END}")

start_time = time.time()

response = client.invoke_agent_runtime(
    agentRuntimeArn=args.agent_runtime_arn,
    runtimeSessionId=session_id,
    payload=payload,
)

for line in response['response'].iter_lines():
    if line:
        line_str = line.decode('utf-8')
        if line_str.startswith("data: "):
            chunk = line_str[6:]
            print(f"{Colors.GREEN}{chunk}{Colors.END}", end="", flush=True)
            time.sleep(0.01)  # Small delay to show streaming effect

end_time = time.time()
print(f"\n{Colors.GREEN}{'─'*50}{Colors.END}")
print(f"{Colors.YELLOW}✨ Response completed in {end_time - start_time:.2f} seconds{Colors.END}\n")
