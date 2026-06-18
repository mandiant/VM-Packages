$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pedetective'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://ntcore.com/files/PE_Detective.zip'
$zipSha256 = '821f4fa1df9d3a39e32f15183126e56af8dacf4690a8fd01bfac6d850ea36263'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName 'PE Detective.exe'
