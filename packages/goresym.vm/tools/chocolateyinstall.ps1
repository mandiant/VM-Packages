$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GoReSym'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/mandiant/GoReSym/releases/download/v3.1.1/GoReSym-windows.zip'
$zipSha256 = 'a345904a2110d5bda198e005bace80fcaed94a3f8b1a8ea926c7d28fd6cb69e0'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
