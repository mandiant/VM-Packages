$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2025.1.zip'
$zipSha256 = '04796ca5f3fae71234f8df273cae8e2eacea864da3db99ee4ed19b00b86f359b'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
