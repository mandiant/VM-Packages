$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
$zipSha256 = '422d79934258325f5c736e3c7a8c0a874b76dbd77ebfa01fb26879ffad9ec038'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
