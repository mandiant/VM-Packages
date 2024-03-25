$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dumpert'
$category = 'Credential Access'

$zipUrl = 'https://github.com/outflanknl/Dumpert/archive/8000ca4c585b0fc317cee69504be22d1ac2ed779.zip'
$zipSha256 = '1ffbf3332db29e834c779008586c386ebbf1ca21e5c081ae6bba1a033d937bec'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
