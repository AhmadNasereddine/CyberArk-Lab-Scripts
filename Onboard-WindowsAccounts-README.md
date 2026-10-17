# CyberArk Account Onboarding Script
This script automates the creation of a new Safe and onboards a Windows domain account into CyberArk using the psPAS PowerShell module.

## Features
* Bypasses SSL validation for lab environments.
* Authenticates via API.
* Creates a new Safe (`Scripting_Lab`) assigned to the `PasswordManager` CPM.
* Onboards a test Windows account (`WindowsAdmin`).