$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RecentFileCacheParser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/RecentFileCacheParser.zip'
$zipSha256 = 'caedc350c64dc5f14f5ae1e6c25d9adfabdfeb51411f176653d6b11281f06b17'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
