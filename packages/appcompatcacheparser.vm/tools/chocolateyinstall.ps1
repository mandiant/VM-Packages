$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AppCompatCacheParser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/AppCompatCacheParser.zip'
$zipSha256 = '58b1a999c1f31e6d28ffcc722e49fadf0254a7ad04c48cde2537a61ccb6d1198'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
