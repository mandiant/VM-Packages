$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v3.10/SQLRecon.exe'
$exeSha256 = 'bda3c27ea01d388a139b57876cd71565bb59d749ca7139db6596e8e761fbdfda'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
