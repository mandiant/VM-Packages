$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'binwalk'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v3.1.0.zip'
$zipSha256 = 'fabf028b31679ffea7a4b10df5ab7be7d73eb1ff3f7772909fb7955c85003efe'
$arguments = ''

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false -arguments $arguments
