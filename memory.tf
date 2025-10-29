# AgentCore Memory
resource "aws_bedrockagentcore_memory" "main" {
  count                 = var.enable_memory ? 1 : 0
  name                  = var.name
  description           = "memory for ${var.name}"
  event_expiry_duration = var.memory_short_term_expiration_days
}

# Memory Strategies
resource "aws_bedrockagentcore_memory_strategy" "session_summarizer" {
  count      = var.enable_memory ? 1 : 0
  memory_id  = aws_bedrockagentcore_memory.main[0].id
  name       = "SessionSummarizer"
  type       = "SUMMARIZATION"
  namespaces = ["/summaries/{actorId}/{sessionId}"]
}

resource "aws_bedrockagentcore_memory_strategy" "preference_learner" {
  count      = var.enable_memory ? 1 : 0
  memory_id  = aws_bedrockagentcore_memory.main[0].id
  name       = "PreferenceLearner"
  type       = "USER_PREFERENCE"
  namespaces = ["/preferences/{actorId}"]
}

resource "aws_bedrockagentcore_memory_strategy" "fact_extractor" {
  count      = var.enable_memory ? 1 : 0
  memory_id  = aws_bedrockagentcore_memory.main[0].id
  name       = "FactExtractor"
  type       = "SEMANTIC"
  namespaces = ["/facts/{actorId}"]
}
