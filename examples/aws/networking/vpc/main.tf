module "vpc" {
  source = "../../../../aws/networking/vpc"

  name       = "example-vpc"
  cidr_block = "10.0.0.0/16"
}
