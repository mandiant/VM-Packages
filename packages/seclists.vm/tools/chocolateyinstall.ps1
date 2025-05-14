$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2025.2.zip'
$zipSha256 = '92e3d894d8fe3a30f1b98dc960ec6c3c98ff2fdd6282bb653ce5167715ef6071'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
