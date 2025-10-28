# Docker provider with ECR authentication
provider "docker" {
  registry_auth {
    address  = "${local.account}.dkr.ecr.${local.region}.amazonaws.com"
    username = "AWS"
    password = data.aws_ecr_authorization_token.token.password
  }
}

# ECR repository for AgentCore runtime
resource "aws_ecr_repository" "main" {
  count                = var.enable_runtime ? 1 : 0
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Build and push Docker image
resource "docker_image" "main" {
  count = var.enable_runtime ? 1 : 0
  name  = "${aws_ecr_repository.main[0].repository_url}:${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  build {
    platform = "linux/arm64"
    context  = var.dockerfile
  }

  triggers = {
    timestamp = timestamp()
  }
}

resource "docker_registry_image" "main" {
  count = var.enable_runtime ? 1 : 0
  name  = docker_image.main[0].name
}

# AgentCore Agent Runtime
resource "aws_bedrockagentcore_agent_runtime" "main" {
  count              = var.enable_runtime ? 1 : 0
  agent_runtime_name = var.name
  role_arn           = aws_iam_role.agentcore_runtime[0].arn

  agent_runtime_artifact {
    container_configuration {
      container_uri = docker_registry_image.main[0].name
    }
  }

  # Handle environment variables: add dummy value if empty to avoid provider bug,
  # and include MEMORY_ID when memory is enabled
  environment_variables = length(var.environment_variables) == 0 ? merge(
    { "DUMMY" = "placeholder" },
    var.enable_memory ? { "MEMORY_ID" = aws_bedrockagentcore_memory.main[0].id } : {}
    ) : merge(
    var.environment_variables,
    var.enable_memory ? { "MEMORY_ID" = aws_bedrockagentcore_memory.main[0].id } : {}
  )

  protocol_configuration {
    server_protocol = var.server_protocol
  }

  network_configuration {
    network_mode = "PUBLIC"
  }

  depends_on = [aws_iam_role_policy.agentcore_runtime]
}

# IAM role for AgentCore runtime
resource "aws_iam_role" "agentcore_runtime" {
  count = var.enable_runtime ? 1 : 0
  name  = "${var.name}-AgentRuntimeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeRolePolicy"
        Effect = "Allow"
        Principal = {
          Service = "bedrock-agentcore.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock-agentcore:${local.region_account}:*"
          }
        }
      }
    ]
  })
}

# IAM policy for AgentCore runtime
resource "aws_iam_role_policy" "agentcore_runtime" {
  count = var.enable_runtime ? 1 : 0
  name  = "BedrockAgentCoreRuntimePolicy"
  role  = aws_iam_role.agentcore_runtime[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRImageAccess"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = [
          "arn:aws:ecr:${local.region_account}:repository/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup"
        ]
        Resource = [
          "arn:aws:logs:${local.region_account}:log-group:/aws/bedrock-agentcore/runtimes/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = [
          "arn:aws:logs:${local.region_account}:log-group:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${local.region_account}:log-group:/aws/bedrock-agentcore/runtimes/*:log-stream:*"
        ]
      },
      {
        Sid    = "ECRTokenAccess"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Resource = ["*"]
      },
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = "cloudwatch:PutMetricData"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "bedrock-agentcore"
          }
        }
      },
      {
        Sid    = "GetAgentAccessToken"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:GetWorkloadAccessToken",
          "bedrock-agentcore:GetWorkloadAccessTokenForJWT",
          "bedrock-agentcore:GetWorkloadAccessTokenForUserId"
        ]
        Resource = [
          "arn:aws:bedrock-agentcore:${local.region_account}:workload-identity-directory/default",
          "arn:aws:bedrock-agentcore:${local.region_account}:workload-identity-directory/default/workload-identity/*"
        ]
      },
      {
        Sid    = "BedrockModelInvocation"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:*::foundation-model/*",
          "arn:aws:bedrock:${local.region_account}:*"
        ]
      },
      {
        Sid    = "CreateMemory"
        Effect = "Allow"
        Action = [
          "bedrock-agentcore:CreateMemory",
          "bedrock-agentcore:CreateEvent",
          "bedrock-agentcore:ListMemories",
          "bedrock-agentcore:ListEvents",
          "bedrock-agentcore:DeleteMemory"
        ]
        Resource = ["*"]
      },
    ]
  })
}
