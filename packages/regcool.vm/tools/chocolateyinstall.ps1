$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
$zipSha256 = 'E3F93417089FB91BF08E306B8B67DF9AC4DA17206F95003063D406F2A999E4D7'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
