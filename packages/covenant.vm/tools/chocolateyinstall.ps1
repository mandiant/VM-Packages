$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Covenant'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/cobbr/Covenant/archive/5decc3ccfab04e6e881ed00c9de649740dac8ad1.zip'
$zipSha256 = '53f532e350b7a43b0dab8e21a5298587b9a2f498c46bed77d443dea32525b525'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
