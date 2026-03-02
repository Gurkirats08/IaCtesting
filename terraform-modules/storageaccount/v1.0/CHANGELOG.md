# CHANGELOG (aligned to versions.tf)
## [2.0.4] - [2023-06-07]

- Remove condition of public_network_access_enabled in resource azurerm_storage_account_network_rules

## [2.0.3] - [2023-05-16]

- Default Public network disabled
- Default SAS disbaled
- Removed role assignment given to Agents
- Removed Advanced Threat protection

## [2.0.2] - [2023-04-12]
### Changed

- Added condition on Blob_properties to not run for FileStorage kind of Storage Accounts

## [2.0.1] - [2023-04-06]
### Added

- Added Advance threat protection resource 

## [2.0.0] - [2023-03-30]
### Changed

- SAS enabled to support Public Monitoring Zone 

## [1.0.9] - [2023-03-28]
### Changed

- Added variables for expiration dates for key vault secrets and CMK

## [1.0.8] - [2023-03-27]
### Changed

- Fixed Kerberos
- Made CMK default

## [1.0.7] - [2023-03-07]
### Changed

- Integrated kerbos.

## [1.0.6] - [2023-02-15]
### Changed

- Removed the access policy resource.
## [1.0.5] - [2022-01-18]
### Added

- Remove tag from lifecycle ignore_changes.
## [1.0.4] - [2022-12-27]
### Added

- Implemented cloud security baseline.

## [1.0.3] - [2022-12-22]
### Added

- Added DependOn for cmk access issue.

## [1.0.2] - [2022-12-21]
### Changed

- Set secrets/keys expiration time for 1 year.

## [1.0.1] - [2022-12-2]
### Fixed
- Removed data source of keyvault.
