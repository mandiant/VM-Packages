$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLECmd'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/SQLECmd.zip'
$zipSha256 = '40a23c2bd6855753e5f39a7cb944cd2e13aecb70ae2c5b3db840c959225454be'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true
