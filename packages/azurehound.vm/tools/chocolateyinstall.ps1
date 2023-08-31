$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureHound'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/BloodHoundAD/AzureHound/releases/download/v2.0.5/azurehound-windows-amd64.zip'
$zipSha256 = 'f091faa36ca44141699bb94b8a2096208d354beb3ef91806b659ed94c2022466'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
