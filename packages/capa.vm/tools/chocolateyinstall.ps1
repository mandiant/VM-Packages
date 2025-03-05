$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/capa/releases/download/v9.1.0/capa-v9.1.0-windows.zip"
$zipSha256 = "579194136730e9c6b31254abca12382534f4eef8b8b4bcf718cc4b31cfb96e05"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
