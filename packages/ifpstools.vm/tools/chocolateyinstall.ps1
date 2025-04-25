$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# IFPSTools.NET includes several tools, but we only create a shortcut for ifpsdasm (and add it to path)
$toolName = 'ifpsdasm'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/Wack0/IFPSTools.NET/releases/download/v2.0.3/ifpstools-net_v2.0.3.zip'
$zipSha256 = '3b642789e4b7eec8faa316df66f7ad588f679a470df7c098453bb4c877f91682'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
