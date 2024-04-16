$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PDBReSym'
$category = 'Utilities'

$zipUrl = 'https://github.com/mandiant/STrace/releases/download/v1.3.3/PDBReSym.zip'
$zipSha256 = '803dfc0321581bc39001f050cdafe672e9e3247e96ffd42606fda3d641f0fd57'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -arguments "--help"
