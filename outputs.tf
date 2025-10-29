output "agentcore_runtime_arn" {
  description = "ARN of the AgentCore runtime"
  value       = var.enable_runtime ? aws_bedrockagentcore_agent_runtime.main[0].agent_runtime_arn : null
}

output "memory_id" {
  description = "ID of the AgentCore memory"
  value       = var.enable_memory ? aws_bedrockagentcore_memory.main[0].id : null
}
