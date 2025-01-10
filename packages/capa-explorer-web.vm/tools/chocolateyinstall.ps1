$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$category = 'Utilities'
$toolName = 'capa Explorer Web'
$zipUrl = 'https://github.com/mandiant/capa/raw/refs/heads/master/web/explorer/releases/capa-explorer-web-v1.0.0-6a2330c.zip'
$zipSha256 = '3a7cf6927b0e8595f08b685669b215ef779eade622efd5e8d33efefadd849025'

$executableName = "index.html"
$iconName = "favicon.ico"
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -executableName $executableName -iconLocation $iconName  -withoutBinFile -innerFolder $true
