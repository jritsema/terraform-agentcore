import requests
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
import asyncio
import subprocess
import json

def get_terraform_output(output_name):
    """Get Terraform output value from the parent directory"""
    result = subprocess.run(
        ["terraform", "output", "-json", output_name],
        cwd="../",
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)

def fetch_access_token(client_id, client_secret, token_url):
    response = requests.post(
        token_url,
        data="grant_type=client_credentials&scope=myagent/invoke",
        headers={'Content-Type': 'application/x-www-form-urlencoded'},
        auth=(client_id, client_secret)
    )
    print(f"Token response status: {response.status_code}")
    if response.status_code != 200:
        print(f"Token response: {response.text}")
        response.raise_for_status()
    return response.json()['access_token']

async def execute_mcp(url, headers=None):
    headers = {**headers} if headers else {}
    async with streamablehttp_client(
        url=url,
        headers=headers,
    ) as (read_stream, write_stream, callA):
        async with ClientSession(read_stream, write_stream) as session:

            # 1. Perform initialization handshake
            print("Initializing MCP...")
            _init_response = await session.initialize()
            print(f"MCP Server Initialize successful! - {_init_response}")

            # 2. List available tools
            print("Listing tools...")
            cursor = True
            tools = []
            while cursor:
                next_cursor = cursor if type(cursor) != bool else None
                list_tools_response = await session.list_tools(next_cursor)
                tools.extend(list_tools_response.tools)
                cursor = list_tools_response.nextCursor

            tool_names = [tool.name for tool in tools]
            tool_names_string = "\n".join(tool_names)
            print(f"List MCP tools. # of tools - {len(tools)}")
            print(f"List of tools - \n{tool_names_string}\n")

            # Test the search tool if available
            if any(tool.name == "x_amz_bedrock_agentcore_search" for tool in tools):
                print("Testing search tool...")
                try:
                    search_result = await session.call_tool(
                        "x_amz_bedrock_agentcore_search",
                        {"query": "calculator"}
                    )
                    print(f"Search result: {search_result}")
                except Exception as e:
                    print(f"Search tool error: {e}")
            else:
                print("Search tool not found")

# Get values from Terraform output
client_id = get_terraform_output("cognito_client_id")
client_secret = get_terraform_output("cognito_client_secret")
gateway_url_output = get_terraform_output("gateway_url")
cognito_domain = get_terraform_output("cognito_domain")

# Get region from AWS CLI or extract from gateway URL
result = subprocess.run(["aws", "configure", "get", "region"], capture_output=True, text=True)
region = result.stdout.strip()

gateway_url = gateway_url_output
token_url = f"https://{cognito_domain}.auth.{region}.amazoncognito.com/oauth2/token"

print(f"Gateway URL: {gateway_url}")
print(f"Token URL: {token_url}")

access_token = fetch_access_token(client_id, client_secret, token_url)
headers = {"Authorization": f"Bearer {access_token}"}

# Test the gateway endpoint first with proper MCP request
mcp_request = {
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
        "protocolVersion": "2024-11-05",
        "capabilities": {},
        "clientInfo": {
            "name": "test-client",
            "version": "1.0.0"
        }
    }
}

test_response = requests.post(gateway_url, headers=headers, json=mcp_request)
print(f"Gateway test response status: {test_response.status_code}")
print(f"Gateway test response: {test_response.text}")

if test_response.status_code == 200:
    asyncio.run(execute_mcp(url=gateway_url, headers=headers))
else:
    print("Gateway test failed, not proceeding with MCP client")
