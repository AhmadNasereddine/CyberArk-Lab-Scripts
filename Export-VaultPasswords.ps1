# 1. Re-Authenticate (Silent Mode)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$SecurePassword = ConvertTo-SecureString "Casemiro_15" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("Administrator", $SecurePassword)
New-PASSession -BaseURI "https://192.168.190.101" -Credential $Credential

# 2. Get All Accounts to find their IDs
$AllAccounts = Get-PASAccount
$ExportData = @()


# 3. Loop through IDs to extract passwords
foreach ($Account in $AllAccounts) {
    Write-Host "Extracting password for account: $($Account.name)..." -ForegroundColor Yellow
    
    try {
        # This API call requires the 'Retrieve accounts' permission on the safe
        $Password = Get-PASAccountPassword -id $Account.id
        
        $ExportData += [PSCustomObject]@{
            AccountName = $Account.name
            Address     = $Account.address
            UserName    = $Account.userName
            Safe        = $Account.safeName
            Platform    = $Account.platformId
            Password    = $Password
        }
    } catch {
        Write-Host "Failed to extract password for $($Account.name) (Missing Safe Permissions)" -ForegroundColor Red
    }
}

# 4. Export to CSV
$ExportPath = "C:\CyberArk_Scripts\Vault_Passwords_Export.csv"
$ExportData | Export-Csv -Path $ExportPath -NoTypeInformation
Write-Host "Successfully exported passwords to $ExportPath" -ForegroundColor Green

# 5. Clean up
Close-PASSession