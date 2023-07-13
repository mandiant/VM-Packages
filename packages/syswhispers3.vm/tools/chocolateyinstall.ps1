$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SysWhispers3'
$category = 'Payload Development'

$zipUrl = 'https://github.com/klezVirus/SysWhispers3/archive/e3d5fc744c2e5c0ae952be0f7dcf498c5a68be4b.zip'
$zipSha256 = '987d04d404ee86536e04c488037fa9c9caa12d35fefdf9c0bc193d1bfed4c96a'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
