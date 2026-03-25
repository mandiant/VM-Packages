$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2026.1.zip'
$zipSha256 = 'fe72b89126070f5b1b32acfa408699e4d1d6a9030380f5ff257735af358c4b31'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
