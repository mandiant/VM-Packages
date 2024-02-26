$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Regshot-x64-Unicode'
$category = 'Registry'

$zipUrl = 'https://sourceforge.net/projects/regshot/files/regshot/1.9.1-beta/Regshot-1.9.1-beta_r321.7z'
$zipSha256 = '5933d59f591e1e68ce7819904f8cb1118fc935bdfe89581599d0560ec9b97cd6'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
