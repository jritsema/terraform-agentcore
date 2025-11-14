variable "name" {
  description = "Name for the AgentCore resources"
  type        = string
}

variable "enable_runtime" {
  description = "Enable AgentCore Runtime"
  type        = bool
  default     = true
}

variable "enable_memory" {
  description = "Enable AgentCore Memory"
  type        = bool
  default     = false
}

variable "enable_code_interpreter" {
  description = "Enable AgentCore Code Interpreter"
  type        = bool
  default     = false
}

variable "enable_browser" {
  description = "Enable AgentCore Browser"
  type        = bool
  default     = false
}

variable "enable_gateway" {
  description = "Enable AgentCore Gateway"
  type        = bool
  default     = false
}

variable "use_cognito_for_auth" {
  description = "Use Cognito User Pool for gateway authentication. If false, custom JWT configuration is required."
  type        = bool
  default     = true
}

variable "gateway_jwt_discovery_url" {
  description = "JWT discovery URL for custom JWT authorizer (required when use_cognito_for_auth is false)"
  type        = string
  default     = null
}

variable "gateway_jwt_allowed_audience" {
  description = "Allowed audience values for JWT token validation (required when use_cognito_for_auth is false)"
  type        = list(string)
  default     = []
}

variable "gateway_jwt_allowed_clients" {
  description = "Allowed client IDs for JWT token validation (optional when use_cognito_for_auth is false)"
  type        = list(string)
  default     = []
}

variable "gateway_mcp_instructions" {
  description = "Instructions for the MCP protocol configuration"
  type        = string
  default     = null
}

variable "gateway_mcp_search_type" {
  description = "Search type for MCP"
  type        = string
  default     = "SEMANTIC"
  validation {
    condition     = var.gateway_mcp_search_type == null ? true : contains(["SEMANTIC", "HYBRID"], var.gateway_mcp_search_type)
    error_message = "Gateway MCP search type must be SEMANTIC or HYBRID."
  }
}

variable "gateway_mcp_supported_versions" {
  description = "Supported MCP protocol versions"
  type        = list(string)
  default     = ["2025-06-18"]
}

variable "server_protocol" {
  description = "Server protocol for AgentCore Runtime"
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "MCP", "A2A"], var.server_protocol)
    error_message = "Server protocol must be HTTP, MCP, or A2A."
  }
}

variable "dockerfile" {
  description = "Path to the Dockerfile context directory"
  type        = string
  default     = "../agent"
}

variable "environment_variables" {
  description = "Environment variables for the AgentCore Runtime"
  type        = map(string)
  default     = {}
}

variable "memory_short_term_expiration_days" {
  description = "Memory short term expiration in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
