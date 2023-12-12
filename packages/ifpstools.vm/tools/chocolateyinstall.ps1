$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# IFPSTools.NET includes several tools, but we only create a shortcut for ifpsdasm (and add it to path)
$toolName = 'ifpsdasm'
$category = 'InnoSetup'

$zipUrl = 'https://github.com/Wack0/IFPSTools.NET/releases/download/v2.0.2/ifpstools-net_v2.0.2.zip'
$zipSha256 = 'bf5242e1b950055b496a5e42a828c687681aee5f259ed262236b0bc52e02e5b8'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
