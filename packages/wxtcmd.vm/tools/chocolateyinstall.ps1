$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WxTCmd'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/WxTCmd.zip'
$zipSha256 = '87d97c832a6c7d82ca57e2213c6e3416a3b4ea5ff5b54db4cc84e48b1cfc424a'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
