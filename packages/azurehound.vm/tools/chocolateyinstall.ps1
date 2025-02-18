$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.2.1/azurehound-windows-amd64.zip'
$zipSha256 = '111ce3f5c15cdcce58d54c5d549b1e36eaa4b78a0a31531548cb9b0f71f78125'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
