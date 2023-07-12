$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MailSniper.ps1'
$category = 'Credential Access'

$ps1Url = 'https://raw.githubusercontent.com/dafthack/MailSniper/f6fd1441feb246ba0d1c6d47f7f3a6dcbe3d2b92/MailSniper.ps1'
$ps1Sha256 = '353eec8f77c54fc914168bbdc111f0766421aaf8d7e4314036e79bf1b08060c6'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256
