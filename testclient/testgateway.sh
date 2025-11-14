#!/bin/bash

set -e

echo "Testing MCP Gateway..."

# Get Terraform outputs (from parent directory)
cd ..
CLIENT_ID=$(terraform output -raw cognito_client_id)
CLIENT_SECRET=$(terraform output -raw cognito_client_secret)
USER_POOL_ID=$(terraform output -raw cognito_user_pool_id)
GATEWAY_URL=$(terraform output -raw gateway_url)
COGNITO_DOMAIN=$(terraform output -raw cognito_domain)
cd testclient

echo "Client ID: $CLIENT_ID"
echo "User Pool ID: $USER_POOL_ID"
echo "Gateway URL: $GATEWAY_URL"
echo "Cognito Domain: $COGNITO_DOMAIN"

# Get JWT token from Cognito OAuth endpoint
echo "Fetching JWT token from OAuth endpoint..."
TOKEN_RESPONSE=$(curl -s -X POST \
  "https://${COGNITO_DOMAIN}.auth.us-east-1.amazoncognito.com/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "${CLIENT_ID}:${CLIENT_SECRET}" \
  -d "grant_type=client_credentials&scope=myagent/invoke")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to get access token:"
  echo "$TOKEN_RESPONSE"
  exit 1
fi

echo "Got access token: ${ACCESS_TOKEN:0:20}..."

# Test MCP gateway with a simple initialize request
echo "Testing MCP gateway..."
MCP_REQUEST='{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2025-06-18",
    "capabilities": {},
    "clientInfo": {
      "name": "test-client",
      "version": "1.0.0"
    }
  }
}'

RESPONSE=$(curl -s -X POST "$GATEWAY_URL" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$MCP_REQUEST")

echo "MCP Response:"
echo "$RESPONSE" | jq .

echo "Gateway test complete!"
