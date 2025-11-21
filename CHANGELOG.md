# Changelog

## 1.0.0 (2025-11-21)


### Features

* **communication:** crate ses-domain module ([dfea7c1](https://github.com/rsturla/terraform-modules/commit/dfea7c1ed3349fc9ce5a3adc23d653ca37ee0f50))
* **communication:** create ses-domain module ([#17](https://github.com/rsturla/terraform-modules/issues/17)) ([dfea7c1](https://github.com/rsturla/terraform-modules/commit/dfea7c1ed3349fc9ce5a3adc23d653ca37ee0f50))
* **containers:** create ecr-repos Terraform module ([#25](https://github.com/rsturla/terraform-modules/issues/25)) ([bf5513f](https://github.com/rsturla/terraform-modules/commit/bf5513f2cc9bb6fd0446eb6e78fc1db26bd8b362))
* **cost-control:** create budgets module ([#28](https://github.com/rsturla/terraform-modules/issues/28)) ([0af1a81](https://github.com/rsturla/terraform-modules/commit/0af1a811754486ecba0fdf4b00237502d4762a89))
* **data-storage:** create backup vault and plan modules ([#26](https://github.com/rsturla/terraform-modules/issues/26)) ([cd2dcd3](https://github.com/rsturla/terraform-modules/commit/cd2dcd3cd120dbd12b12b4ca9da955b183642632))
* **data-storage:** create private and public S3 modules ([#20](https://github.com/rsturla/terraform-modules/issues/20)) ([9a3ae2b](https://github.com/rsturla/terraform-modules/commit/9a3ae2b916b0e1661f0d4df1d33c103c07250c13))
* **data-storage:** create RDS Postgres module ([#34](https://github.com/rsturla/terraform-modules/issues/34)) ([0dd2e89](https://github.com/rsturla/terraform-modules/commit/0dd2e8902023a353cf7a2443bb96af48e5df4c15))
* **identity:** create github-actions-role module ([#19](https://github.com/rsturla/terraform-modules/issues/19)) ([860a23f](https://github.com/rsturla/terraform-modules/commit/860a23f7e4609647628c2d26158f2be8b95a0dd9))
* **identity:** create identity-center module ([#29](https://github.com/rsturla/terraform-modules/issues/29)) ([7e7f290](https://github.com/rsturla/terraform-modules/commit/7e7f290d8dd4611317ba19cba2400d576f490eac))
* **misc:** create cloudformation-stack module ([#48](https://github.com/rsturla/terraform-modules/issues/48)) ([686e05d](https://github.com/rsturla/terraform-modules/commit/686e05d2237b6a7ef3e5e5ae44aa6ccaa2838c26))
* **networking:** allow creating NAT Instances instead of NAT Gateways ([#22](https://github.com/rsturla/terraform-modules/issues/22)) ([fc21f25](https://github.com/rsturla/terraform-modules/commit/fc21f250092a6da83a3efc68f9454a9d44933ce3))
* **networking:** create acm-certificates module ([#21](https://github.com/rsturla/terraform-modules/issues/21)) ([985e283](https://github.com/rsturla/terraform-modules/commit/985e283491e5587eb11a0bdab229dbd949f2196a))
* **networking:** create cloudfront-redirect module ([#18](https://github.com/rsturla/terraform-modules/issues/18)) ([9e360fa](https://github.com/rsturla/terraform-modules/commit/9e360fae75ec25947165b0aa92dba97e3b616cb1))
* **networking:** create route53 modules ([#16](https://github.com/rsturla/terraform-modules/issues/16)) ([3d5837b](https://github.com/rsturla/terraform-modules/commit/3d5837bf013583696ed1d0fb57de71287ced72fe))
* **networking:** create VPC, Flow Log and NACL modules ([#5](https://github.com/rsturla/terraform-modules/issues/5)) ([4af1c6a](https://github.com/rsturla/terraform-modules/commit/4af1c6a2c3533add36ed64ccb389edb8079f12d3))
* **networking:** support scheduled NAT instances ([#33](https://github.com/rsturla/terraform-modules/issues/33)) ([9116ac6](https://github.com/rsturla/terraform-modules/commit/9116ac6eadaf72e89c3693073d73ed380ec72d3a))
* **security:** create cloudformation-stacksets module ([#47](https://github.com/rsturla/terraform-modules/issues/47)) ([fc4216a](https://github.com/rsturla/terraform-modules/commit/fc4216aede5463e7c123fd3c525032f37c7f6613))
* **security:** create cloudtrail module ([#57](https://github.com/rsturla/terraform-modules/issues/57)) ([2b96f23](https://github.com/rsturla/terraform-modules/commit/2b96f232b2e0d09949bf4058d4c83119d47d2199))
* **security:** create inspector multi-region module ([#14](https://github.com/rsturla/terraform-modules/issues/14)) ([53b7f6f](https://github.com/rsturla/terraform-modules/commit/53b7f6f32d2aec3482e457728b46714509678a95))
* **security:** create organizations module ([#27](https://github.com/rsturla/terraform-modules/issues/27)) ([35fb508](https://github.com/rsturla/terraform-modules/commit/35fb508cc51a87ff4ad2aafd4a18c182aeb4acc4))
* **security:** create securityhub multi-region module ([#13](https://github.com/rsturla/terraform-modules/issues/13)) ([b030e8d](https://github.com/rsturla/terraform-modules/commit/b030e8dcce97f50c2f05b4c4c5172fb319701b62))


### Bug Fixes

* **cost-control:** budgets cost filter not required ([#46](https://github.com/rsturla/terraform-modules/issues/46)) ([224a7c0](https://github.com/rsturla/terraform-modules/commit/224a7c00606ffe1b5b269cd004b69cda357040ec))
* **identity:** refactor identity center module ([#51](https://github.com/rsturla/terraform-modules/issues/51)) ([e32391a](https://github.com/rsturla/terraform-modules/commit/e32391a0c055b512fa8e61cf35e24e79b77c6263))
* move conventional commits to own workflow ([#7](https://github.com/rsturla/terraform-modules/issues/7)) ([78f21a2](https://github.com/rsturla/terraform-modules/commit/78f21a212af5fc96ec41d8ddb1a744a3fa41c1d2))
* **security:** change iam_user_access_to_billing type ([#50](https://github.com/rsturla/terraform-modules/issues/50)) ([fe6df96](https://github.com/rsturla/terraform-modules/commit/fe6df962c30d7e2858537a8eba710bbe8e484dd5))
* **security:** ignore administration_role_arn ([#52](https://github.com/rsturla/terraform-modules/issues/52)) ([9fbe7a8](https://github.com/rsturla/terraform-modules/commit/9fbe7a8909efb3c3c3d7f76db8abf353063a47e3))
