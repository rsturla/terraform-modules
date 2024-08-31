module "vpc" {
  source = "../../../../modules/aws/networking/vpc"

  name                = "example-vpc"
  cidr_block          = "10.0.0.0/16"
  nat_instance_count  = 1
  nat_instance_ami_id = "ami-0011c76c040f11f0f"
}
