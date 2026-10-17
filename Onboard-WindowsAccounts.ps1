# 1. Bypass SSL and Authenticate
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

Write-Host "Connecting to CyberArk API..." -ForegroundColor Cyan
New-PASSession -BaseURI "https://192.168.190.101" -Credential (Get-Credential)

# 2. Create a New Safe
Write-Host "Creating the Scripting_Lab Safe..." -ForegroundColor Cyan
Add-PASSafe -SafeName "Scripting_Lab" -Description "Automated via psPAS" -ManagingCPM "PasswordManager" -NumberOfDaysRetention 7

# 3. Onboard a Test Account into the New Safe
Write-Host "Onboarding the WindowsAdmin account..." -ForegroundColor Cyan
$SecurePassword = ConvertTo-SecureString "SuperSecret123!" -AsPlainText -Force

Add-PASAccount -SafeName "Scripting_Lab" -platformID "WinDesktopLocal" -address "192.168.190.50" -userName "WindowsAdmin" -password $SecurePassword

# 4. Safely Close the API Session
Write-Host "Closing API Session..." -ForegroundColor Cyan
Close-PASSession

Write-Host "Automation Complete!" -ForegroundColor Green