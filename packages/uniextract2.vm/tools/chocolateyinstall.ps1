$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'UniExtract'
$category = 'Utilities'

$zipUrl = "https://github.com/Bioruebe/UniExtract2/releases/download/v2.0.0-rc.3/UniExtractRC3.zip"
$zipSha256 = "03170680b80f2afdf824f4d700c11b8e2dac805a4d9bd3d24f53e43bd7131c3a"

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -innerFolder $true