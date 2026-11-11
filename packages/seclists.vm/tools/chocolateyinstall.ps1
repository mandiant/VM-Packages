$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2026.2.zip'
$zipSha256 = '8c225d3a377897021e822d63985a137f7864b71d8aba88cf8698a5aa399a73c8'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
