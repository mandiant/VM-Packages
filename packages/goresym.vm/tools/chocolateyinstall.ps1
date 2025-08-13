$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.1.2/GoReSym-windows.zip'
$zipSha256 = 'bcad66f944ba528d6a71fd709ca8f7ac0e1cff094eae80f458e1dd335c985e05'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
