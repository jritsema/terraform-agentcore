data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

locals {
  region         = data.aws_region.current.region
  account        = data.aws_caller_identity.current.account_id
  region_account = "${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}"
}
