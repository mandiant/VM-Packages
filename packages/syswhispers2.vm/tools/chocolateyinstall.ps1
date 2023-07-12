$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'syswhispers'
$category = 'Evasion'

$zipUrl = 'https://github.com/jthuraisamy/SysWhispers2/archive/05ad0d9ec769fac2776c992d2cb55b09bd604f9a.zip'
$zipSha256 = '71a3be8727b26ec4b8092d7bed07d0f9'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
