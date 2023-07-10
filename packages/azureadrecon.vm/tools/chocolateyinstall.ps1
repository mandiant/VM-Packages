$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

Try {
    Install-Module -Name Microsoft.Graph -ErrorAction Stop
}
Catch {
    Write-Host "Failed to install Microsoft.Graph module. Error: $_"
    Exit
}

$toolName = 'AzureADRecon'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/adrecon/AzureADRecon/archive/18410c1a630c085091ad15a768ac742fd2513902.zip'
$zipSha256 = '51e0af14ae0e35300fe6fe8fa96ebbce86abb34a597fe81fd16b7358ebe13aae'

$powershellCommand = 'Import-Module Az; .\AzureADRecon.ps1'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -powershellCommand $powershellCommand
