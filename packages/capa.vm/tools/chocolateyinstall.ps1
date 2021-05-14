$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'capa'
$category = 'Utilities'

$zipUrl = "https://github.com/mandiant/capa/releases/download/v1.6.3/capa-v1.6.3-windows.zip"
$zipSha256 = "00e8d32941b3a1a58a164efc38826099fd70856156762647c4bbd9e946e41606"

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -consoleApp $true

