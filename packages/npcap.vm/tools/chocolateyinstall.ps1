$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'npcap'
$category = 'Networking'

$exeUrl = 'https://npcap.com/dist/npcap-1.79.exe'
$exeSha256 = 'a95577ebbc67fc45b319e2ef3a55f4e9b211fe82ed4cb9d8be6b1a9e2425ce53'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
