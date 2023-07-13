$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Get-LAPSPasswords'
$category = 'Credential Access'

$ps1Url = 'https://raw.githubusercontent.com/kfosaaen/Get-LAPSPasswords/2aeffed5dc16c0d7be91ba67b79cfaaf1da1eecd/Get-LAPSPasswords.ps1'
$ps1Sha256 = '2256ef01ad1a82633abc376246f0d05784a26f16fc99f1b66e6d42a3fafa2eb4'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256
