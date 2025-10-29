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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_bedrockagentcore_agent_runtime.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_agent_runtime) | resource |
| [aws_bedrockagentcore_memory.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory) | resource |
| [aws_bedrockagentcore_memory_strategy.fact_extractor](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_bedrockagentcore_memory_strategy.preference_learner](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_bedrockagentcore_memory_strategy.session_summarizer](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/bedrockagentcore_memory_strategy) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/ecr_repository) | resource |
| [aws_iam_role.agentcore_runtime](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.agentcore_runtime](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/resources/iam_role_policy) | resource |
| [docker_image.main](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [docker_registry_image.main](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/registry_image) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/caller_identity) | data source |
| [aws_ecr_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/ecr_authorization_token) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.18.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_dockerfile"></a> [dockerfile](#input\_dockerfile) | Path to the Dockerfile context directory | `string` | `"../agent"` | no |
| <a name="input_enable_memory"></a> [enable\_memory](#input\_enable\_memory) | Enable AgentCore Memory | `bool` | `false` | no |
| <a name="input_enable_runtime"></a> [enable\_runtime](#input\_enable\_runtime) | Enable AgentCore Runtime | `bool` | `true` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the AgentCore Runtime | `map(string)` | `{}` | no |
| <a name="input_memory_short_term_expiration_days"></a> [memory\_short\_term\_expiration\_days](#input\_memory\_short\_term\_expiration\_days) | Memory short term expiration in days | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the AgentCore resources | `string` | n/a | yes |
| <a name="input_server_protocol"></a> [server\_protocol](#input\_server\_protocol) | Server protocol for AgentCore Runtime | `string` | `"HTTP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agentcore_runtime_arn"></a> [agentcore\_runtime\_arn](#output\_agentcore\_runtime\_arn) | ARN of the AgentCore runtime |
| <a name="output_memory_id"></a> [memory\_id](#output\_memory\_id) | ID of the AgentCore memory |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
