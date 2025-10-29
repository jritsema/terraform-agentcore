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
