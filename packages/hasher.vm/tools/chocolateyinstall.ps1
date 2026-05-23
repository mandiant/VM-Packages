$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Hasher'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/hasher.zip'
$zipSha256 = 'A8A343013D6ED5B6988EBCE1B3A561DF51AB5928BC3A0F489A7E175F8F6F89D4'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $true
