$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LDAPNomNom'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/lkarlslund/ldapnomnom/releases/download/v1.2.0/ldapnomnom-windows-amd64.exe'
$exeSha256 = 'b56d067b0f6c9368f044d12bc73bd55da36bc766f60409f219cc77100d7f5ba3'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
