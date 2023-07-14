$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hashcat'
$category = 'Credential Access'

$zipUrl = 'https://github.com/hashcat/hashcat/releases/download/v6.2.6/hashcat-6.2.6.7z'
$zipSha256 = '96697e9ef6a795d45863c91d61be85a9f138596e3151e7c2cd63ccf48aaa8783'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
