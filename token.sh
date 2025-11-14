#!/bin/bash

CLIENT_ID=$(terraform output -raw cognito_client_id)
CLIENT_SECRET=$(terraform output -raw cognito_client_secret)
TOKEN_URL=$(terraform output -raw token_url)
GATEWAY_URL=$(terraform output -raw gateway_url)

ACCESS_TOKEN=$(curl -s -X POST "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" \
  | jq '.access_token' -r)

echo "Gateway URL: $GATEWAY_URL"
echo""
echo "Token: $ACCESS_TOKEN"
