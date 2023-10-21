$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDPAPI'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/SharpDPAPI/archive/02992ff2c5c48f38602b096367c6107857dae8e9.zip'
$zipSha256 = 'dd0bd7ceedf87a6952c1e6d8c1865f434f316b187c3f783fe176ad323e7b0f81'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
