$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpDump'
$category = 'Credential Access'

$zipUrl = 'https://github.com/GhostPack/SharpDump/archive/41cfcf9b1abed2da79a93c201cbd38fbbe31684c.zip'
$zipSha256 = 'c7ddbf34fc9546638d05344727c7a07bbdf492f4f2313456ee5097a5dbea942a'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
