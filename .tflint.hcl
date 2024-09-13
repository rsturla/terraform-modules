config {
  format     = "compact"
  plugin_dir = "~/.tflint.d/plugins"

  call_module_type    = "local"
  force               = false
  disabled_by_default = false

  ignore_module = {}
}

plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_documented_variables" {
  enabled  = true
  required = true
  message  = "Documented variables are required"
}

rule "terraform_unused_declarations" {
  enabled = true
  message = "Unused declarations are forbidden"
}

rule "terraform_deprecated_interpolation" {
  enabled = true
  message = "Deprecated interpolation syntax is forbidden"
}
