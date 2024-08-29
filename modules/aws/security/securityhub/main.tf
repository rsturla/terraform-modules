# This file is generated. Do not edit! Your changes will be lost.
module "securityhub_us_east_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "us-east-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "us-east-1"

  providers = {
    aws = aws.us_east_1
  }
}
module "securityhub_us_east_2" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "us-east-2")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "us-east-2"

  providers = {
    aws = aws.us_east_2
  }
}
module "securityhub_us_west_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "us-west-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "us-west-1"

  providers = {
    aws = aws.us_west_1
  }
}
module "securityhub_us_west_2" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "us-west-2")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "us-west-2"

  providers = {
    aws = aws.us_west_2
  }
}
module "securityhub_ap_south_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-south-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-south-1"

  providers = {
    aws = aws.ap_south_1
  }
}
module "securityhub_ap_northeast_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-northeast-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-northeast-1"

  providers = {
    aws = aws.ap_northeast_1
  }
}
module "securityhub_ap_northeast_2" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-northeast-2")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-northeast-2"

  providers = {
    aws = aws.ap_northeast_2
  }
}
module "securityhub_ap_southeast_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-southeast-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-southeast-1"

  providers = {
    aws = aws.ap_southeast_1
  }
}
module "securityhub_ap_southeast_2" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-southeast-2")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-southeast-2"

  providers = {
    aws = aws.ap_southeast_2
  }
}
module "securityhub_ap_northeast_3" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ap-northeast-3")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ap-northeast-3"

  providers = {
    aws = aws.ap_northeast_3
  }
}
module "securityhub_ca_central_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "ca-central-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "ca-central-1"

  providers = {
    aws = aws.ca_central_1
  }
}
module "securityhub_eu_central_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "eu-central-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "eu-central-1"

  providers = {
    aws = aws.eu_central_1
  }
}
module "securityhub_eu_west_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "eu-west-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "eu-west-1"

  providers = {
    aws = aws.eu_west_1
  }
}
module "securityhub_eu_west_2" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "eu-west-2")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "eu-west-2"

  providers = {
    aws = aws.eu_west_2
  }
}
module "securityhub_eu_west_3" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "eu-west-3")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "eu-west-3"

  providers = {
    aws = aws.eu_west_3
  }
}
module "securityhub_eu_north_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "eu-north-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "eu-north-1"

  providers = {
    aws = aws.eu_north_1
  }
}
module "securityhub_sa_east_1" {
  source = "./single-region"

  create_resources                   = contains(var.opt_in_regions, "sa-east-1")
  standards                          = var.enabled_standards
  external_member_accounts           = var.external_member_accounts
  delegated_administrator_account_id = var.delegated_administrator_account_id
  is_aggregate_region                = var.aggregate_region == "sa-east-1"

  providers = {
    aws = aws.sa_east_1
  }
}
