# AgentCore Browser
resource "aws_bedrockagentcore_browser" "main" {
  count       = var.enable_browser ? 1 : 0
  name        = "${var.name}_browser"
  description = "Browser for ${var.name}"

  network_configuration {
    network_mode = "PUBLIC"
  }

  tags = var.tags
}

# IAM policy for browser access
resource "aws_iam_role_policy" "browser" {
  count = var.enable_browser && var.enable_runtime ? 1 : 0
  name  = "${var.name}-BedrockAgentCoreBrowserPolicy"
  role  = aws_iam_role.agentcore_runtime[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BedrockAgentCoreBrowserFullAccess"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:CreateBrowser",
          "bedrock-agentcore:ListBrowsers",
          "bedrock-agentcore:GetBrowser",
          "bedrock-agentcore:DeleteBrowser",
          "bedrock-agentcore:StartBrowserSession",
          "bedrock-agentcore:ListBrowserSessions",
          "bedrock-agentcore:GetBrowserSession",
          "bedrock-agentcore:StopBrowserSession",
          "bedrock-agentcore:UpdateBrowserStream",
          "bedrock-agentcore:ConnectBrowserAutomationStream",
          "bedrock-agentcore:ConnectBrowserLiveViewStream"
        ]
        Resource = aws_bedrockagentcore_browser.main[0].browser_arn
      }
    ]
  })
}
