generate MODULE="":
  #!/usr/bin/env bash
  echo "Generating Modules"
  bin_dir=$(mktemp -d)
  pushd tools/generate-aws-multi-region
  go build -o $bin_dir/generate-aws-multi-region .
  popd
  $bin_dir/generate-aws-multi-region -dir {{MODULE}} -regionsFile ./modules/aws/regions.json
  rm -rf $bin_dir
