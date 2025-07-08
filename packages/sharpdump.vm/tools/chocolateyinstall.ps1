$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDump'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/GhostPack/SharpDump/archive/41cfcf9b1abed2da79a93c201cbd38fbbe31684c.zip'
$zipSha256 = 'c7ddbf34fc9546638d05344727c7a07bbdf492f4f2313456ee5097a5dbea942a'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
