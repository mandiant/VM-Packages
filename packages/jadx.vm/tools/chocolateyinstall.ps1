$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'jadx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/skylot/jadx/releases/download/v1.5.7/jadx-gui-1.5.7-win.zip'
$zipSha256 = '996bf3e956d1eac7726899f8fe5d5c9fcdc05b36b3e97db46455ad81e1612bd5'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName 'jadx-gui-1.5.7.exe'
