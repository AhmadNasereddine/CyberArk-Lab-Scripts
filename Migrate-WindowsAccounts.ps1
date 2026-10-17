# 1. Re-Authenticate
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
New-PASSession -BaseURI "https://192.168.190.101" -Credential (Get-Credential)

# 2. Grab the accounts
$WindowsAccounts = Get-PASAccount | Where-Object { $_.name -match "win" }
$NewSafeName = "Windows_Migrated_Accounts"

# 3. The Migration Loop (Fixed with -reason)
foreach ($Account in $WindowsAccounts) {
    Write-Host "Migrating account: $($Account.userName)..." -ForegroundColor Yellow
    
    # We added the -reason parameter to satisfy your Vault's security policy
    $RawPassword = Get-PASAccountPassword -AccountID $Account.id -reason "Automated account migration"
    $SecurePassword = ConvertTo-SecureString $RawPassword -AsPlainText -Force
    
    # Recreate in the new Safe
    Add-PASAccount -SafeName $NewSafeName -platformID $Account.platformId -address $Account.address -userName $Account.userName -password $SecurePassword
    
    # Delete the old one
    Remove-PASAccount -AccountID $Account.id
    
    Write-Host "Successfully migrated $($Account.userName) to $NewSafeName!" -ForegroundColor Green
}

# 4. Clean up
Close-PASSession