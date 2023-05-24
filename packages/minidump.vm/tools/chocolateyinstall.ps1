$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MiniDump'
$category = 'Credential Access'

$zipUrl = 'https://github.com/Mr-Un1k0d3r/MiniDump/archive/98a21941831b90b203fdbfb253cd0b3dc27a0475.zip'
$zipSha256 = '975d43c2aa7a2a84ecdd925db1fd39fec4aa610b99da45d5661979c120261b82'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
