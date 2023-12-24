$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Net-GPPPassword'
$category = 'Reconnaissance'

$exeUrl = 'https://github.com/outflanknl/Net-GPPPassword/releases/download/v1/Net-GPPPassword_dotNET_v4.exe'
$exeSha256 = '899c51f6a9ffdbf6228f0c4e22f90c5119dc5fbe0417ce1d346783c13f247e08'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
