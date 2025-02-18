$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v3.1.1/floss-v3.1.1-windows.zip"
$zipSha256 = "6c71089b8c629c69424b042769f1565f71adc6cd24b2f8d3713c96fa7fdac2fb"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
