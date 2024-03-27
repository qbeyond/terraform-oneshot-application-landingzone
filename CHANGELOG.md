# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
