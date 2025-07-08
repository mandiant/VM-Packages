$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDBReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/STrace/releases/download/v1.3.6/PDBReSym.zip'
$zipSha256 = '90435d53c02f477c9b3b997bf0abab5b68302294edde05f97e820a6046038fd9'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -arguments "--help"
