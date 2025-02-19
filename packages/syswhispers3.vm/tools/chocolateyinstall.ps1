$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SysWhispers3'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/klezVirus/SysWhispers3/archive/e3d5fc744c2e5c0ae952be0f7dcf498c5a68be4b.zip'
$zipSha256 = '987d04d404ee86536e04c488037fa9c9caa12d35fefdf9c0bc193d1bfed4c96a'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
