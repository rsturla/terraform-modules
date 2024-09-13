module "vpc" {
  source = "../../../../modules/aws/networking/vpc"

  name               = "example-vpc"
  cidr_block         = "10.0.0.0/16"
  nat_instance_count = 1
  // Power on at 8AM
  nat_instance_schedule_power_on_cron = "0 8 * * *"
  // Power off at 5PM
  nat_instance_schedule_power_off_cron = "0 17 * * *"
}
