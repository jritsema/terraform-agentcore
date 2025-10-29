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
