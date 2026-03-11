$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.3/GoReSym-windows.zip'
$zipSha256 = '7015ba45e94ef19e212e363d7b165fcef729e090c62ec82a227f5a605d3cd2cb'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
