$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FLOSS'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/flare-floss/releases/download/v2.3.0/floss-v2.3.0-windows.zip"
$zipSha256 = "30afca951815545e68c76feae0675127fe742e5b3b16f75ba751aef3985ab053"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

