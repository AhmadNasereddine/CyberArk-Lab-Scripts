# CyberArk User Activity Export
This script automates the extraction of last login timestamps for all users in the CyberArk Vault using the psPAS module.

## Files Included
* `Export-UserLogins.ps1`: The PowerShell script that authenticates silently and loops through all Vault users to extract their `LastSuccessLoginDate`.
* `User_Last_Logins.csv`: The exported output data containing `UserName`, `UserType`, and `LastLogin`.