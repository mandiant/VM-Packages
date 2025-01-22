$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = 'Forensic'

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.0.1/hayabusa-3.0.1-win-x64.zip"
$zipSha256 = 'e3d732dc0deb9c0ad623364b6fdea3dcd744123821bf1843ec2943f084a7fd19'

$executableName = $toolName.ToLower() + "-3.0.1-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
