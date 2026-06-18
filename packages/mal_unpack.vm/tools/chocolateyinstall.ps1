$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'mal_unpack'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/hasherezade/mal_unpack/releases/download/1.0/mal_unpack64.zip'
$zipSha256 = '2ff766297c088e6a24b2ff9d92a11fc7585fe8c8444668161cd1e9875fb373a1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName 'mal_unpack.exe' -consoleApp $true -arguments '--help'
