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
