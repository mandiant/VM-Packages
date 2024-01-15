$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner64'
$category = 'Utilities'

$zipUrl = 'https://github.com/OALabs/BlobRunner/releases/download/v0.0.5/blobrunner64.zip'
$zipSha256 = '325e3e26ccdce53cdd8b6665c7ed7d1765fc1c56cd088a5b4433593682c9f503'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
