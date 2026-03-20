$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pylingual'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Pip-Install 'https://github.com/syssec-utd/pylingual/archive/99c74eeff5262c0200a3d378298af1f736e20b01.zip'

$pyPath = (Get-Command py).Source
VM-Install-Shortcut $toolName $category -executablePath $toolName -consoleApp $true -arguments "--help" -iconLocation $pyPath
