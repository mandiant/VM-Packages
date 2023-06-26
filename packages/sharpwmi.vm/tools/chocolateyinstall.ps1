$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpWMI'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/GhostPack/SharpWMI/archive/0600f57aeb4733ba6fec585388af2f1ac4483b58.zip'
$zipSha256 = '0dbdd04a8a62e16de40373ae416b732cd48fb642ac7b3ff243bb9580249058f5'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
