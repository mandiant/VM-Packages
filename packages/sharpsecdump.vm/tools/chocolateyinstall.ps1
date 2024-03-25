$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpSecDump'
$category = 'Credential Access'

$zipUrl = 'https://github.com/G0ldenGunSec/SharpSecDump/archive/ef2463688e405fad0fabb001b3d8869db51da0e0.zip'
$zipSha256 = '10108c1817d21f747e10317ccca14b58d3e060c7c3fe268eccf81ef58e448ae4'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
