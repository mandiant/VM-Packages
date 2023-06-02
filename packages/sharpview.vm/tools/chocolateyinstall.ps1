$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpView'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/tevora-threat/SharpView/archive/b60456286b41bb055ee7bc2a14d645410cca9b74.zip'
$zipSha256 = '1e5f54b9317ac053fe51e373b3e3b830573e2d14612bf4a038750a6c6284fb3d'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
