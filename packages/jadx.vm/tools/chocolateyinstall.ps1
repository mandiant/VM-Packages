$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'jadx'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-gui-1.5.6-win.zip'
$zipSha256 = '6e070b197d4e40275d10f6559a1661bdd2e2bb325e9ef4181c7ac1286b274d99'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName 'jadx-gui-1.5.6.exe'
