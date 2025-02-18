$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hollows_hunter'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.0.2/hollows_hunter32.zip'
$zipSha256 = '81f9e36d9aac860a8cb8e49715e9c70af6c9a52daa619cac86d71f473c959838'
$zipUrl_64 = 'https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.0.2/hollows_hunter64.zip'
$zipSha256_64 = '1616812ac67ac3113d4fb065ec51f4bb50b8461ce41a969708c7d9ae17dfb49d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -consoleApp $true

