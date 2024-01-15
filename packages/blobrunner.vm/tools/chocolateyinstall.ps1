$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'blobrunner'
$category = 'Utilities'

$zipUrl = 'https://github.com/OALabs/BlobRunner/releases/download/v0.0.5/blobrunner.zip'
$zipSha256 = '369ed39086e40fe9ae5404b52cafe0a9b747abb11f2d33d73e5a51097d0ae2a4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
