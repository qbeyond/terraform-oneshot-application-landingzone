# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Set the `skip_provider_registration` of `azurerm` provider in created terraform configuration to `var.skip_provider_registration` instead of `true`

### Changed

- rename `vnet.tf` to `network.tf` as it contains Resource Group for `Network`
- remove `locals` from `network.tf`/`vnet.tf`
- fix location not inserted into 'locals.tf'

## [1.0.1] - 2024-03-25

### Changed

- fix 'vnet_config' is 'null'

## [1.0.0] - 2023-09-08

- initial release
