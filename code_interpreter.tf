# AgentCore Code Interpreter
resource "aws_bedrockagentcore_code_interpreter" "main" {
  count       = var.enable_code_interpreter ? 1 : 0
  name        = "${var.name}_code_interpreter"
  description = "Code interpreter for ${var.name}"

  network_configuration {
    network_mode = "PUBLIC"
  }

  tags = var.tags
}

# IAM policy for code interpreter access
resource "aws_iam_role_policy" "code_interpreter" {
  count = var.enable_code_interpreter ? 1 : 0
  name  = "${var.name}_BedrockAgentCoreCodeInterpreterPolicy"
  role  = aws_iam_role.agentcore_runtime[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockAgentCoreCodeInterpreterFullAccess"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:CreateCodeInterpreter",
          "bedrock-agentcore:StartCodeInterpreterSession",
          "bedrock-agentcore:InvokeCodeInterpreter",
          "bedrock-agentcore:StopCodeInterpreterSession",
          "bedrock-agentcore:DeleteCodeInterpreter",
          "bedrock-agentcore:ListCodeInterpreters",
          "bedrock-agentcore:GetCodeInterpreter",
          "bedrock-agentcore:GetCodeInterpreterSession",
          "bedrock-agentcore:ListCodeInterpreterSessions"
        ]
        Resource = aws_bedrockagentcore_code_interpreter.main[0].code_interpreter_arn,
      }
    ]
  })
}
