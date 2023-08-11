$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Rubeus'
$category = 'Credential Access'

$zipUrl = 'https://github.com/GhostPack/Rubeus/archive/refs/heads/master.zip'
$zipSha256 = 'DC61768AF588A5FCC1CEDC491E8DF81BC652A96A1A032741034E40B75EC404F2'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
