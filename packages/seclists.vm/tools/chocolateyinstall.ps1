$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2024.4.zip'
$zipSha256 = 'f38e9a9f3ae78e479efd0793036c5077fca551f4130845babe88177bcd13b1b5'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
