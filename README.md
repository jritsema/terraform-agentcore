# terraform-agentcore

A Terraform module for running AI agents on Amazon Bedrock AgentCore.

Includes a python test client to invoke the agent.


## Usage

### AgentCore Runtime

Deploy a code project with a Dockerfile to AgentCore Runtime.

```hcl
name = "myagent"

enable_runtime = true

server_protocol = "HTTP" # or MCP, or A2A

dockerfile = "../"

environment_variables = {
  FOO = "bar"
}
```

### AgentCore Memory

```hcl
name = "myagent"

enable_memory = true

memory_short_term_expiration_days = 30
```

### AgentCore Code Interpreter

```hcl
name = "myagent"

enable_code_interpreter = true
```

### AgentCore Browser

```hcl
name = "myagent"

enable_browser = true
```

### AgentCore Gateway

```hcl
name = "myagent"

enable_gateway = true

# Optional: Use Cognito for authentication (default: true)
use_cognito_for_auth = true

# Optional: Custom JWT configuration (when use_cognito_for_auth = false)
gateway_jwt_discovery_url = "https://your-jwt-provider.com/.well-known/jwks.json"
gateway_jwt_allowed_audience = ["your-audience"]
gateway_jwt_allowed_clients = ["client-id-1", "client-id-2"]
```


## Development

```
 Choose a make command to run

  init      project initialization - install tools and register git hook
  checks    run all pre-commit checks
  summary   summary of terraform resource changes
```

Note that if using Amazon Q Developer CLI, the [Hashicorp MCP server]() is pre-configured in the `terraform` agent.

```sh
q chat --agent terraform
```

### Test Client

Once the agent has deployed to AgentCore Runtime, you can use the included [test client](./testclient/) to invoke it.

One time setup of python virtual environment and packages:

```sh
make init && make install
```

Then invoke the agent:

```sh
make start
```


## Terraform module documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.18.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.18.0 |
| <a name="provider_docker"></a> [docker](#provider\_docker) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_bedrockagentcore_agent_runtime.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_agent_runtime) | resource |
| [aws_bedrockagentcore_browser.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_browser) | resource |
| [aws_bedrockagentcore_code_interpreter.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_code_interpreter) | resource |
| [aws_bedrockagentcore_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_gateway) | resource |
| [aws_bedrockagentcore_memory.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory) | resource |
| [aws_bedrockagentcore_memory_strategy.fact_extractor](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_bedrockagentcore_memory_strategy.preference_learner](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_bedrockagentcore_memory_strategy.session_summarizer](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_cognito_resource_server.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_pool.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/cognito_user_pool_domain) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/ecr_repository) | resource |
| [aws_iam_role.agentcore_runtime](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role) | resource |
| [aws_iam_role.gateway](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.agentcore_runtime](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.browser](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.code_interpreter](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.gateway_minimal](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.memory](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [docker_image.main](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [docker_registry_image.main](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/registry_image) | resource |
| [random_string.domain_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/ecr_authorization_token) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dockerfile"></a> [dockerfile](#input\_dockerfile) | Path to the Dockerfile context directory | `string` | `"../agent"` | no |
| <a name="input_enable_browser"></a> [enable\_browser](#input\_enable\_browser) | Enable AgentCore Browser | `bool` | `false` | no |
| <a name="input_enable_code_interpreter"></a> [enable\_code\_interpreter](#input\_enable\_code\_interpreter) | Enable AgentCore Code Interpreter | `bool` | `false` | no |
| <a name="input_enable_gateway"></a> [enable\_gateway](#input\_enable\_gateway) | Enable AgentCore Gateway | `bool` | `false` | no |
| <a name="input_enable_memory"></a> [enable\_memory](#input\_enable\_memory) | Enable AgentCore Memory | `bool` | `false` | no |
| <a name="input_enable_runtime"></a> [enable\_runtime](#input\_enable\_runtime) | Enable AgentCore Runtime | `bool` | `true` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the AgentCore Runtime | `map(string)` | `{}` | no |
| <a name="input_gateway_jwt_allowed_audience"></a> [gateway\_jwt\_allowed\_audience](#input\_gateway\_jwt\_allowed\_audience) | Allowed audience values for JWT token validation (required when use\_cognito\_for\_auth is false) | `list(string)` | `[]` | no |
| <a name="input_gateway_jwt_allowed_clients"></a> [gateway\_jwt\_allowed\_clients](#input\_gateway\_jwt\_allowed\_clients) | Allowed client IDs for JWT token validation (optional when use\_cognito\_for\_auth is false) | `list(string)` | `[]` | no |
| <a name="input_gateway_jwt_discovery_url"></a> [gateway\_jwt\_discovery\_url](#input\_gateway\_jwt\_discovery\_url) | JWT discovery URL for custom JWT authorizer (required when use\_cognito\_for\_auth is false) | `string` | `null` | no |
| <a name="input_gateway_mcp_instructions"></a> [gateway\_mcp\_instructions](#input\_gateway\_mcp\_instructions) | Instructions for the MCP protocol configuration | `string` | `null` | no |
| <a name="input_gateway_mcp_search_type"></a> [gateway\_mcp\_search\_type](#input\_gateway\_mcp\_search\_type) | Search type for MCP | `string` | `"SEMANTIC"` | no |
| <a name="input_gateway_mcp_supported_versions"></a> [gateway\_mcp\_supported\_versions](#input\_gateway\_mcp\_supported\_versions) | Supported MCP protocol versions | `list(string)` | <pre>[<br>  "2025-06-18"<br>]</pre> | no |
| <a name="input_memory_short_term_expiration_days"></a> [memory\_short\_term\_expiration\_days](#input\_memory\_short\_term\_expiration\_days) | Memory short term expiration in days | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the AgentCore resources | `string` | n/a | yes |
| <a name="input_server_protocol"></a> [server\_protocol](#input\_server\_protocol) | Server protocol for AgentCore Runtime | `string` | `"HTTP"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_use_cognito_for_auth"></a> [use\_cognito\_for\_auth](#input\_use\_cognito\_for\_auth) | Use Cognito User Pool for gateway authentication. If false, custom JWT configuration is required. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agentcore_runtime_arn"></a> [agentcore\_runtime\_arn](#output\_agentcore\_runtime\_arn) | ARN of the AgentCore runtime |
| <a name="output_browser_arn"></a> [browser\_arn](#output\_browser\_arn) | ARN of the AgentCore browser |
| <a name="output_browser_id"></a> [browser\_id](#output\_browser\_id) | ID of the AgentCore browser |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | Client ID for gateway authentication |
| <a name="output_code_interpreter_arn"></a> [code\_interpreter\_arn](#output\_code\_interpreter\_arn) | ARN of the AgentCore code interpreter |
| <a name="output_code_interpreter_id"></a> [code\_interpreter\_id](#output\_code\_interpreter\_id) | ID of the AgentCore code interpreter |
| <a name="output_cognito_client_id"></a> [cognito\_client\_id](#output\_cognito\_client\_id) | ID of the Cognito User Pool Client for gateway authentication |
| <a name="output_cognito_client_secret"></a> [cognito\_client\_secret](#output\_cognito\_client\_secret) | Secret of the Cognito User Pool Client for gateway authentication |
| <a name="output_cognito_domain"></a> [cognito\_domain](#output\_cognito\_domain) | Domain of the Cognito User Pool for OAuth endpoints |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | ID of the Cognito User Pool for gateway authentication |
| <a name="output_gateway_arn"></a> [gateway\_arn](#output\_gateway\_arn) | ARN of the AgentCore gateway |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | ID of the AgentCore gateway |
| <a name="output_gateway_role_arn"></a> [gateway\_role\_arn](#output\_gateway\_role\_arn) | ARN of the Gateway execution role |
| <a name="output_gateway_url"></a> [gateway\_url](#output\_gateway\_url) | URL of the AgentCore gateway |
| <a name="output_memory_id"></a> [memory\_id](#output\_memory\_id) | ID of the AgentCore memory |
| <a name="output_token_url"></a> [token\_url](#output\_token\_url) | Token URL for gateway authentication |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
