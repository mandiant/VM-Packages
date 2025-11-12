$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# IFPSTools.NET includes several tools, but we only create a shortcut for ifpsdasm (and add it to path)
$toolName = 'ifpsdasm'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Wack0/IFPSTools.NET/releases/download/v2.0.4/ifpstools-net_v2.0.4.zip'
$zipSha256 = '41d6e11bd7e5d956eddfba4ac4c5cc525eea68f8fcb201d0677cb1e246251e12'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
