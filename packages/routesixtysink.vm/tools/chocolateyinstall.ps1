$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RouteSixtySink'
$category = 'Web Application'

$zipUrl = 'https://github.com/mandiant/route-sixty-sink/archive/59195003c84d75fabf6cc573c233dfb60d631f8a.zip'
$zipSha256 = '860df7a6f8b8b135e27e731d1cc11a61837a390fc7da46652f82920040802f15'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
