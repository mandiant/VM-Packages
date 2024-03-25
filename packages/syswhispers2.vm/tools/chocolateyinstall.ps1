$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SysWhispers2'
$category = 'Payload Development'

$zipUrl = 'https://github.com/jthuraisamy/SysWhispers2/archive/05ad0d9ec769fac2776c992d2cb55b09bd604f9a.zip'
$zipSha256 = '4741ad22fe05a9dc8e89885b37a458c12b286a9de2e3f306b57c7a5ef5f7596e'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
