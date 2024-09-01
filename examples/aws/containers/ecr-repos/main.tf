module "ecr_repos" {
  source = "../../../../modules/aws/containers/ecr-repos"

  repositories = {
    example = {}
    another-example = {
      image_tag_mutability                    = "IMMUTABLE"
      external_account_ids_with_read_access   = ["586861619874"]
      external_account_ids_with_write_access  = ["586861619874"]
      external_account_ids_with_lambda_access = ["586861619874"]
      tags = {
        Hello = "World"
      }
    }
  }

  tags_all = {
    Hi = "There"
  }
}
