# CyberArk Account Migration Script
This script automates the migration of Windows accounts from an existing Safe to a new target Safe using the psPAS module.

## Features
* Retrieves all accounts matching the "win" naming convention.
* Retrieves the password for each account using a mandatory `-reason` string to comply with Vault security policies.
* Recreates the account in the `Windows_Migrated_Accounts` Safe.
* Deletes the original account to complete the migration.