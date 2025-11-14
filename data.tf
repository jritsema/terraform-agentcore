data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

locals {
  region         = data.aws_region.current.region
  account        = data.aws_caller_identity.current.account_id
  region_account = "${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}"
  token_url      = var.enable_gateway && var.use_cognito_for_auth ? "https://${aws_cognito_user_pool_domain.gateway[0].domain}.auth.${local.region}.amazoncognito.com/oauth2/token" : null
}
