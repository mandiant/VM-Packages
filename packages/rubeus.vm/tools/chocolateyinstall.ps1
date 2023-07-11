$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Credential Access'

$zipUrl = 'https://github.com/GhostPack/Rubeus/archive/refs/heads/master.zip'
$zipSha256 = 'f6d1650043e528e24b4bc5c1f24e64ff0c4bbcf72537b84b1d8f866dd8ab8ccb'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
