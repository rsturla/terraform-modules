module "budgets" {
  source = "../../../../modules/aws/cost-control/budgets"

  budgets = {
    RDSMonthly = {
      limit_amount = 100
      cost_filter = [{
        name   = "Service"
        values = ["Amazon Relational Database Service"]
      }]
    }
    EC2Monthly = {
      limit_amount = 150
      cost_filter = [{
        name   = "Service"
        values = ["Amazon Elastic Compute Cloud - Compute"]
      }]
    }
  }

  notifications = [
    {
      comparison_operator        = "GREATER_THAN"
      notification_type          = "ACTUAL"
      threshold                  = 100
      threshold_type             = "PERCENTAGE"
      subscriber_email_addresses = []
    }
  ]
}
