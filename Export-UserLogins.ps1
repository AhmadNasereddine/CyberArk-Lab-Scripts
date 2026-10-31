# 1. Re-Authenticate (Silent Mode)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$SecurePassword = ConvertTo-SecureString "Casemiro_15" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("Administrator", $SecurePassword)

New-PASSession -BaseURI "https://192.168.190.101" -Credential $Credential

# 2. Get All Vault Users
$AllUsers = Get-PASUser
$LoginsReport = @()

# 3. Loop through users to pull detailed login data
foreach ($User in $AllUsers) {
    Write-Host "Checking activity for user: $($User.username)..." -ForegroundColor Yellow
    $UserDetails = Get-PASUser -id $User.id
    $LoginsReport += [PSCustomObject]@{
        UserName  = $UserDetails.username
        UserType  = $UserDetails.userType
        LastLogin = $UserDetails.LastSuccessLoginDate
    }
}

# 4. Export to CSV
$ExportPath = "C:\CyberArk_Scripts\User_Last_Logins.csv"
$LoginsReport | Export-Csv -Path $ExportPath -NoTypeInformation
Write-Host "Successfully exported last logins to $ExportPath" -ForegroundColor Green

# 5. Clean up
Close-PASSession