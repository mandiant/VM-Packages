$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpUp'
$category = 'Exploitation'

$zipUrl = 'https://github.com/GhostPack/SharpUp/archive/7e172961002125417a0f8a8447de0cb579f7d0e8.zip'
$zipSha256 = '6bf0c25dcd322f3f058d474f827ab3b772cbd7e8ad1a0010a0b8fda3d2a0a761'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
