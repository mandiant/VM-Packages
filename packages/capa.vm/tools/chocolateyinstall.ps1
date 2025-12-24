$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/capa/releases/download/v9.3.1/capa-v9.3.1-windows.zip"
$zipSha256 = "d6e05a7c0c2171c4e476032d205267c03787db2ecedb7717e45a64b9f5895023"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
