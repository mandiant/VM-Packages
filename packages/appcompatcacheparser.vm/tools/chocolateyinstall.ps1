$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AppCompatCacheParser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/AppCompatCacheParser.zip'
$zipSha256 = '58B1A999C1F31E6D28FFCC722E49FADF0254A7AD04C48CDE2537A61CCB6D1198'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
