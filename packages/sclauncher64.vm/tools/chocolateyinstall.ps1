$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher64'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.6/sclauncher64.exe'
$exeSha256 = 'b8eea28ba340b2c1db1932b3356327c04834090452054f49b0809452605521e5'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
