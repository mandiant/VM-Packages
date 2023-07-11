$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'jd-gui'
$category = 'Disassemblers'

$zipUrl = 'https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-windows-1.6.6.zip'
$zipSha256 = '79c231399d3d39d14fce7607728336acb47a6e02e9e1c5f2fa16e2450c0c46cb'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
