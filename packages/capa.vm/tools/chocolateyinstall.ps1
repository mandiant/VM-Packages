$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/capa/releases/download/v9.4.0/capa-v9.4.0-windows.zip"
$zipSha256 = "670ab1a58b81f59cb57533bf4021ac1e7033fbe9b5d5cc180f796976081e3bb5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
