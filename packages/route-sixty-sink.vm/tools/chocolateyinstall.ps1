$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RouteSixtySink'
$category = 'Web Application'

$zipUrl = 'https://github.com/mandiant/route-sixty-sink/releases/download/v1.0.0/route-sixty-sink-win-x64.zip'
$zipSha256 = 'deef7a27d7cfce6d2d0fdab6e9cd5d9a0527a58538d8dcc8801de53cddeba876'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -innerFolder $true
