$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpView'
$Category = 'Reconnaissance'

$zipUrl = 'https://github.com/tevora-threat/SharpView/archive/b60456286b41bb055ee7bc2a14d645410cca9b74.zip'
$zipSha256 = 'b5b2dd91fe22f56fb846d849052fc3205f177cbd067069e6d829e38eea0aca49'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
