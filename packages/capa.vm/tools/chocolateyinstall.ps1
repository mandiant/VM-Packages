$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/capa/releases/download/v10.0.0/capa-v10.0.0-windows.zip"
$zipSha256 = "8712991044321dbb2a5b0d60f7a5327a50c9c30a295e7ddb5c1088cb17fb59df"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
