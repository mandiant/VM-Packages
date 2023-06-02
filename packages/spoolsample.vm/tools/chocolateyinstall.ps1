$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SpoolSample'
$category = 'Exploitation'

$zipUrl = 'https://github.com/leechristensen/SpoolSample/archive/688971e69cbe9240ea84bdd38f732dd9817110f8.zip'
$zipSha256 = '1e5f54b9317ac053fe51e373b3e3b830573e2d14612bf4a038750a6c6284fb3d'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
