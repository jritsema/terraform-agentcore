output "gateway_role_arn" {
  description = "ARN of the Gateway execution role"
  value       = var.enable_gateway ? aws_iam_role.gateway[0].arn : null
}

output "agentcore_runtime_arn" {
  description = "ARN of the AgentCore runtime"
  value       = var.enable_runtime ? aws_bedrockagentcore_agent_runtime.main[0].agent_runtime_arn : null
}

output "memory_id" {
  description = "ID of the AgentCore memory"
  value       = var.enable_memory ? aws_bedrockagentcore_memory.main[0].id : null
}

output "code_interpreter_arn" {
  description = "ARN of the AgentCore code interpreter"
  value       = var.enable_code_interpreter ? aws_bedrockagentcore_code_interpreter.main[0].code_interpreter_arn : null
}

output "code_interpreter_id" {
  description = "ID of the AgentCore code interpreter"
  value       = var.enable_code_interpreter ? aws_bedrockagentcore_code_interpreter.main[0].code_interpreter_id : null
}

output "browser_arn" {
  description = "ARN of the AgentCore browser"
  value       = var.enable_browser ? aws_bedrockagentcore_browser.main[0].browser_arn : null
}

output "browser_id" {
  description = "ID of the AgentCore browser"
  value       = var.enable_browser ? aws_bedrockagentcore_browser.main[0].browser_id : null
}

output "gateway_arn" {
  description = "ARN of the AgentCore gateway"
  value       = var.enable_gateway ? aws_bedrockagentcore_gateway.main[0].gateway_arn : null
}

output "gateway_id" {
  description = "ID of the AgentCore gateway"
  value       = var.enable_gateway ? aws_bedrockagentcore_gateway.main[0].gateway_id : null
}

output "gateway_url" {
  description = "URL of the AgentCore gateway"
  value       = var.enable_gateway ? aws_bedrockagentcore_gateway.main[0].gateway_url : null
}

output "client_id" {
  description = "Client ID for gateway authentication"
  value       = var.enable_gateway && var.use_cognito_for_auth ? aws_cognito_user_pool_client.gateway[0].id : null
}

output "token_url" {
  description = "Token URL for gateway authentication"
  value       = local.token_url
}

output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool for gateway authentication"
  value       = var.enable_gateway && var.use_cognito_for_auth ? aws_cognito_user_pool.gateway[0].id : null
}

output "cognito_client_id" {
  description = "ID of the Cognito User Pool Client for gateway authentication"
  value       = var.enable_gateway && var.use_cognito_for_auth ? aws_cognito_user_pool_client.gateway[0].id : null
}

output "cognito_client_secret" {
  description = "Secret of the Cognito User Pool Client for gateway authentication"
  value       = var.enable_gateway && var.use_cognito_for_auth ? aws_cognito_user_pool_client.gateway[0].client_secret : null
  sensitive   = true
}

output "cognito_domain" {
  description = "Domain of the Cognito User Pool for OAuth endpoints"
  value       = var.enable_gateway && var.use_cognito_for_auth ? aws_cognito_user_pool_domain.gateway[0].domain : null
}
