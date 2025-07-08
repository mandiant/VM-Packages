$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'dll_to_exe'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/hasherezade/dll_to_exe/releases/download/v1.1/dll_to_exe.exe'
$exeSha256 = '930c29f3f36443d6e3ecf3fa2e9c39251f0e66a1e1c0e290ed8c1cf0cc7789f8'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
