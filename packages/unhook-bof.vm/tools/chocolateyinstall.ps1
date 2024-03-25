$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Unhook BOF'
$category = 'Payload Development'

$zipUrl = 'https://github.com/rsmudge/unhook-bof/archive/fa3c8d8a397719c5f2310334e6549bea541b209c.zip'
$zipSha256 = '086f7ded18af7b397be78f63a7b4879bb1a6722f4b192d0139a02863332089ef'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
