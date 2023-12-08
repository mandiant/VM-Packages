$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AmcacheParser'
$category = 'Forensic'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/AmcacheParser.zip'
$zipSha256 = '7b78aa7f26287c6b9b3bf68d3bbccc372687760edf9ae84fafceaed3de535566'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
