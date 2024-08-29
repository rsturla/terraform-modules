# This file is generated. Do not edit! Your changes will be lost.
module "inspector_us_east_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "us-east-1")
  is_aggregate_region = var.aggregate_region == "us-east-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_east_1
  }
}
module "inspector_us_east_2" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "us-east-2")
  is_aggregate_region = var.aggregate_region == "us-east-2"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_east_2
  }
}
module "inspector_us_west_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "us-west-1")
  is_aggregate_region = var.aggregate_region == "us-west-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_west_1
  }
}
module "inspector_us_west_2" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "us-west-2")
  is_aggregate_region = var.aggregate_region == "us-west-2"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.us_west_2
  }
}
module "inspector_ap_south_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-south-1")
  is_aggregate_region = var.aggregate_region == "ap-south-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_south_1
  }
}
module "inspector_ap_northeast_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-northeast-1")
  is_aggregate_region = var.aggregate_region == "ap-northeast-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_1
  }
}
module "inspector_ap_northeast_2" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-northeast-2")
  is_aggregate_region = var.aggregate_region == "ap-northeast-2"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_2
  }
}
module "inspector_ap_southeast_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-southeast-1")
  is_aggregate_region = var.aggregate_region == "ap-southeast-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_southeast_1
  }
}
module "inspector_ap_southeast_2" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-southeast-2")
  is_aggregate_region = var.aggregate_region == "ap-southeast-2"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_southeast_2
  }
}
module "inspector_ap_northeast_3" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ap-northeast-3")
  is_aggregate_region = var.aggregate_region == "ap-northeast-3"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ap_northeast_3
  }
}
module "inspector_ca_central_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "ca-central-1")
  is_aggregate_region = var.aggregate_region == "ca-central-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.ca_central_1
  }
}
module "inspector_eu_central_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "eu-central-1")
  is_aggregate_region = var.aggregate_region == "eu-central-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_central_1
  }
}
module "inspector_eu_west_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "eu-west-1")
  is_aggregate_region = var.aggregate_region == "eu-west-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_1
  }
}
module "inspector_eu_west_2" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "eu-west-2")
  is_aggregate_region = var.aggregate_region == "eu-west-2"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_2
  }
}
module "inspector_eu_west_3" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "eu-west-3")
  is_aggregate_region = var.aggregate_region == "eu-west-3"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_west_3
  }
}
module "inspector_eu_north_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "eu-north-1")
  is_aggregate_region = var.aggregate_region == "eu-north-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.eu_north_1
  }
}
module "inspector_sa_east_1" {
  source = "./single-region"

  create_resources    = contains(var.opt_in_regions, "sa-east-1")
  is_aggregate_region = var.aggregate_region == "sa-east-1"

  delegated_administrator_account_id = var.delegated_administrator_account_id
  auto_enable_member_accounts        = var.auto_enable_member_accounts
  enabled_account_ids                = var.enabled_account_ids
  resource_types                     = var.resource_types

  providers = {
    aws = aws.sa_east_1
  }
}
