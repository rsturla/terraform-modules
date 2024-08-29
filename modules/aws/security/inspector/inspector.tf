# This file is generated. Do not edit! Your changes will be lost.
module "inspector_us_east_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "us-east-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_east_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_us_east_2" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "us-east-2")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_east_2
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_us_west_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "us-west-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_west_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_us_west_2" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "us-west-2")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_west_2
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_south_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-south-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_south_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_northeast_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-northeast-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_northeast_2" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-northeast-2")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_2
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_southeast_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-southeast-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_southeast_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_southeast_2" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-southeast-2")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_southeast_2
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ap_northeast_3" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ap-northeast-3")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_3
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_ca_central_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "ca-central-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ca_central_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_eu_central_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "eu-central-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_central_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_eu_west_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "eu-west-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_eu_west_2" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "eu-west-2")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_2
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_eu_west_3" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "eu-west-3")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_3
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_eu_north_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "eu-north-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_north_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
module "inspector_sa_east_1" {
  source = "./single-region"

  create_resources = contains(var.opt_in_regions, "sa-east-1")

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.sa_east_1
  }

  depends_on = [
    aws_inspector2_organization_configuration.this
  ]
}
