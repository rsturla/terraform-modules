generate MODULE="":
  #!/usr/bin/env bash
  echo "Generating Modules"
  bin_dir=$(mktemp -d)
  pushd tools/generate-aws-multi-region
  go build -o $bin_dir/generate-aws-multi-region .
  popd
  $bin_dir/generate-aws-multi-region -dir {{MODULE}} -regionsFile ./modules/aws/regions.json
  rm -rf $bin_dir

build-ami name image bucket region="eu-west-1":
  #!/usr/bin/env bash
  set -euxo pipefail
  echo "Building AMI"
  pushd ./images
  mkdir -p .osbuild/outputs
  podman run \
    --rm --privileged \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/.osbuild/config.toml:/config.toml \
    -v $(pwd)/.osbuild/outputs:/outputs \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    --env AWS_* \
    quay.io/centos-bootc/bootc-image-builder:latest \
      --type ami \
      --aws-ami-name {{name}} \
      --aws-bucket {{bucket}} \
      --aws-region {{region}} \
      {{image}}
  popd
