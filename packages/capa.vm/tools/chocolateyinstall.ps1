$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v7.4.0/capa-v7.4.0-windows.zip"
$zipSha256 = "4ec2f7cd025751ee897e4818cda4ae572969848053b913d4d3e84ed7ac0af040"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
