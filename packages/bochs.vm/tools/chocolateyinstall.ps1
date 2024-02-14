$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Bochs x86 PC emulator'
$category = 'Debuggers'

$exeUrl = 'https://sourceforge.net/projects/bochs/files/bochs/2.7/Bochs-win64-2.7.exe/download'
$exeSha256 = 'a7428585b30ec3633c00bd38ef9dbb2d6c91cb4c29daa39a3c9b6b89e719ba90'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $false
