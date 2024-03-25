$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Outflank C2 Tool Collection'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/outflanknl/C2-Tool-Collection/archive/f02df22a206ee329bc582a8427d1aa1e54309d9a.zip'
$zipSha256 = '825e3372f6caf540ecbc20f31af6f4b9e711bd6ce64fb09d7d151cf4224de3d8'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
