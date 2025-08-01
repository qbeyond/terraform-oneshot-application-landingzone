# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2025-08-01

### Changed

- Rename `subscription_logical_name` to `application_name`.
- Subnets moved to local variable and change subnet creation.
- Rename file `virtual_machine.tf` to `vm.tf` and change the code model.
- Terraform and vm modules version to be added by variable.
- Changed nsg model.
- Delete deprecated variable.
- Fix version constraints.
- Network template.
- Defaults resources groups in main template by variable.
- Variables and variable group in azure-pipeline template by variable.
- Updated tfvars with new data model.

### Added

- Set up variables in locals.tf.
- NSG files templates and assign to subnets by boolean variable.
- New code templates for VM.
- SQL template.
- README template.

## [2.1.1] - 2025-05-30

### Changed

- Performed a dependency upgrade

## [2.1.0] - 2025-03-04

### Added

- `env` variable now can also be set to `shr`

## [2.0.2] - 2024-10-11

- fix [27466](https://github.com/hashicorp/terraform-provider-azurerm/issues/27466)

## [2.0.1] - 2024-05-14

### fixed

- fixed condition in additional_tags variable

## [2.0.0] - 2024-03-27

### Changed

- hard code `subscription_logical_name` in created repo to avoid changes on subscription rename

### Added

- Set tags at subscription level. Should be used when tags are not managed centrally (version of `archetype-lib` `>=3.0.0`)

## [1.1.0] - 2024-03-27

### Added

- Set the `skip_provider_registration` of `azurerm` provider in created terraform configuration to `var.skip_provider_registration` instead of `true`

### Changed

- rename `vnet.tf` to `network.tf` as it contains Resource Group for `Network`
- remove `locals` from `network.tf`/`vnet.tf`
- fix location not inserted into 'locals.tf'
- use pessimistic version constrained in template to prevent upgrade of major versions
- fix `/azure-pipelines.yml (Line: 22, Col: 12): While parsing a block mapping, did not find expected key.`
- use 1.7.5 as terraform version in pipeline

## [1.0.1] - 2024-03-25

### Changed

- fix 'vnet_config' is 'null'

## [1.0.0] - 2023-09-08

- initial release
