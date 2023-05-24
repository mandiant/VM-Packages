$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'KeeThief'
$category = 'Credential Access'

$zipUrl = 'https://github.com/GhostPack/KeeThief/archive/04f3fbc0ba87dbcd9011ad40a1382169dc5afd59.zip'
$zipSha256 = '2fe020645855564ce1d0236c3e83e8d66a09c91c00d95a40b88cbe9ffd5ca204'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
