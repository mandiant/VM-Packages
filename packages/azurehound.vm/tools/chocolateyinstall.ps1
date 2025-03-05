$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.3.0/azurehound-windows-amd64.zip'
$zipSha256 = 'b2bc506dddb2920c87b1cc9e37f8dd5e28e3f4daa95714a5e8992179f1a0ad58'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
