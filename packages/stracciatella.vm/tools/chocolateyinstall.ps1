$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Stracciatella'
$category = 'Command & Control'

$zipUrl = 'https://github.com/mgeeky/Stracciatella/archive/refs/heads/master.zip'
$zipSha256 = 'db6f32b336dc02aa1dd0577a10348c1ce5558d144f889e63cacff8a9612df2a3'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
