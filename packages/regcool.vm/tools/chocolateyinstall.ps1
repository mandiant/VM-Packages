$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
$zipSha256 = 'e3f93417089fb91bf08e306b8b67df9ac4da17206f95003063d406f2a999e4d7'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
