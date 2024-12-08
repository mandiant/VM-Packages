$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = 'File Information'

VM-Pip-Install 'magika==0.5.0'
$executablePath = "$(where.exe $toolName)"
VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -arguments $arguments
