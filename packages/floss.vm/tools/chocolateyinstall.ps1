$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v3.2.0/floss-v3.2.0-windows.zip"
$zipSha256 = "c0c73bb99d043fedd8e913038b65d1591fd6308cd938d8a91df87b733b369af5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
