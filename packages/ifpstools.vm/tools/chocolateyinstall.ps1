$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# IFPSTools.NET includes several tools, but we only create a shortcut for ifpsdasm (and add it to path)
$toolName = 'ifpsdasm'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Wack0/IFPSTools.NET/releases/download/v2.0.5/ifpstools-net_v2.0.5.zip'
$zipSha256 = '34c61bec455a0543ddbb63b8208d8ff8e18f518921ad60191853493481057c2c'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
