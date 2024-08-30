module "github_actions_roles" {
  source = "../../../../modules/aws/identity/github-actions-role"

  create_openid_connect_provider = true
  name                           = "test"
  repository                     = "owner/repo"
  git_pattern                    = "ref:refs/heads/main"

  policy_arns = [
    # Please restrict the permissions to the minimum required for your use case
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
}
