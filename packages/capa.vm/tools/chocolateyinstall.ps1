$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/capa/releases/download/v9.2.1/capa-v9.2.1-windows.zip"
$zipSha256 = "2220c31fb081ccdb7b140313638fc10e8cf25771375b66b299cdc931494e282d"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
