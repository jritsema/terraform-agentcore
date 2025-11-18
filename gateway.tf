# IAM role for gateway execution
resource "aws_iam_role" "gateway" {
  count = var.enable_gateway ? 1 : 0
  name  = "${var.name}-GatewayExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "bedrock-agentcore.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Minimal policy for gateway (no permissions by default)
resource "aws_iam_role_policy" "gateway_minimal" {
  count = var.enable_gateway ? 1 : 0
  name  = "${var.name}-GatewayMinimalPolicy"
  role  = aws_iam_role.gateway[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "MinimalGatewayAccess"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${local.region}:${local.account}:*"
      },
      {
        Sid    = "LambdaInvokeAccess"
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "arn:aws:lambda:${local.region}:${local.account}:function:*"
      }
    ]
  })
}

# Cognito User Pool (when use_cognito_for_auth is true)
resource "aws_cognito_user_pool" "gateway" {
  count = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  name  = "${var.name}-gateway-pool"
}

resource "aws_cognito_user_pool_domain" "gateway" {
  count        = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  domain       = "${var.name}-gateway-${random_string.domain_suffix[0].result}"
  user_pool_id = aws_cognito_user_pool.gateway[0].id
}

resource "random_string" "domain_suffix" {
  count   = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "aws_cognito_resource_server" "gateway" {
  count      = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  identifier = var.name
  name       = var.name

  user_pool_id = aws_cognito_user_pool.gateway[0].id

  scope {
    scope_name        = "invoke"
    scope_description = "Invoke gateway API"
  }
}

resource "aws_cognito_user_pool_client" "gateway" {
  count        = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  name         = "${var.name}-gateway-client"
  user_pool_id = aws_cognito_user_pool.gateway[0].id

  generate_secret                      = true
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH"]
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["${aws_cognito_resource_server.gateway[0].identifier}/invoke"]

  depends_on = [aws_cognito_resource_server.gateway]
}

# OAuth2 Credential Provider for Cognito
resource "aws_bedrockagentcore_oauth2_credential_provider" "cognito" {
  count = var.enable_gateway && var.use_cognito_for_auth ? 1 : 0
  name  = "${var.name}-cognito-credentials"

  credential_provider_vendor = "CustomOauth2"
  oauth2_provider_config {
    custom_oauth2_provider_config {
      client_id_wo                  = aws_cognito_user_pool_client.gateway[0].id
      client_secret_wo              = aws_cognito_user_pool_client.gateway[0].client_secret
      client_credentials_wo_version = 1

      oauth_discovery {
        discovery_url = "https://cognito-idp.${local.region}.amazonaws.com/${aws_cognito_user_pool.gateway[0].id}/.well-known/openid-configuration"
      }
    }
  }
}

# AgentCore Gateway
resource "aws_bedrockagentcore_gateway" "main" {
  count           = var.enable_gateway ? 1 : 0
  name            = "${var.name}-gateway"
  description     = "Gateway for ${var.name}"
  role_arn        = aws_iam_role.gateway[0].arn
  authorizer_type = "CUSTOM_JWT"
  protocol_type   = "MCP"

  authorizer_configuration {
    custom_jwt_authorizer {
      discovery_url   = var.use_cognito_for_auth ? "https://cognito-idp.${local.region}.amazonaws.com/${aws_cognito_user_pool.gateway[0].id}/.well-known/openid-configuration" : var.gateway_jwt_discovery_url
      allowed_clients = var.use_cognito_for_auth ? [aws_cognito_user_pool_client.gateway[0].id] : var.gateway_jwt_allowed_clients
    }
  }

  dynamic "protocol_configuration" {
    for_each = var.gateway_mcp_instructions != null || var.gateway_mcp_search_type != null || length(var.gateway_mcp_supported_versions) > 0 ? [1] : []
    content {
      mcp {
        instructions       = var.gateway_mcp_instructions
        search_type        = var.gateway_mcp_search_type
        supported_versions = var.gateway_mcp_supported_versions
      }
    }
  }

  tags = var.tags
}
