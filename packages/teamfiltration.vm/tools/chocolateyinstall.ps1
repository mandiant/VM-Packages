$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TeamFiltration'
$category = 'Exploitation'

$zipUrl = 'https://github.com/Flangvik/TeamFiltration/releases/download/v3.5.0/TeamFiltration-Win-v3.5.0.zip'
$zipSha256 = 'c91362172789aa47f45200fac925c5c8ade35cd9a8863f154d27dc5e0a2ed916'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
