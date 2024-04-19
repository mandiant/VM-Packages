$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDBReSym'
$category = 'Utilities'

$zipUrl = 'https://github.com/mandiant/STrace/releases/download/v1.3.4/PDBReSym.zip'
$zipSha256 = '4d162243daf94b03fbf03189490e442045f54dad1a63c024e5bd05a238d56bb8'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -arguments "--help"
