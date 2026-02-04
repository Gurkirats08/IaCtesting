# CHANGELOG (aligned to versions.tf)
## [2.0.2] - [2023-05-12]

- Include default Key Vault firewall configuration
- Update publicNetworkAccess value to "Disabled" as Terraform sees this as case sensitive
- Update the resource provider version to the latest

## [2.0.1] - [2023-05-09]

### Changed

- Keyvault creation with Azapi to support successful resource creation

## [1.0.6] - [2023-04-27]

### Changed

- Disable public network

## [1.0.5] - [2023-02-24]

### Changed

- Change RBAC Assignment to include subscription scope

## [1.0.4] - [2023-02-14]

### Changed

- Used role-based access control (RBAC) to grant permissions to manage key vaults

## [1.0.3] - [2023-01-17]

### Features

- Multiple access policies can be added for different group/user/service principal/managed identity.

## [1.0.2] - [2022-12-15]

### Changed

- Changed `"soft_delete_retention_days"` from 7 to 90 days

## [1.0.1] - [2022-12-05]

### Added

- Added `"Purge"` permissions for secrets, keys and certifiates to avoid Terraform destroy failure

## [1.0.0] - [2022-11-25]

### Added

- Initialization

### Added
### Changed
### Fixed
### Features
