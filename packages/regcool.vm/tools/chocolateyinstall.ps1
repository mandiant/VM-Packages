$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
$zipSha256 = '3a30a6c33e54860049eb67b0ef77538b1905f957bc29509dd850e33aa8138bea'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
