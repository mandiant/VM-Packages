$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

#vars for invoke-thehash
$toolName = 'Invoke-TheHash'
$category = 'Lateral Movement'

# install invoke-thehash and import module
$zipUrl = 'https://github.com/Kevin-Robertson/Invoke-TheHash/archive/refs/heads/master.zip'
$zipSha256 = '3eb5db79e4c05fefcd85518b0b155ae75f6475dfe758e88901e9bff2fed2db6f'
$powershellCommand = 'Import-Module .\Invoke-TheHash.psd1;'
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
