$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Unhook BOF'
$category = 'Command & Control'

$zipUrl = 'https://github.com/rsmudge/unhook-bof/archive/refs/heads/master.zip'
$zipSha256 = '5015772371b536e076a3fe0a29de2a166295c59ba6d2d33014ee3ffff502ba4c'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
