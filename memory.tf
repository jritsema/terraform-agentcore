# AgentCore Memory
resource "aws_bedrockagentcore_memory" "main" {
  count                 = var.enable_memory ? 1 : 0
  name                  = var.name
  description           = "memory for ${var.name}"
  event_expiry_duration = var.memory_short_term_expiration_days
}
