$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LDAPNomNom'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/lkarlslund/ldapnomnom/releases/download/v1.1.0/ldapnomnom-windows-amd64.exe'
$exeSha256 = '5e8d04c49ec9bac3e5269c5054dab440fd521a3840b9c8702e8ecadc01d392a6'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
