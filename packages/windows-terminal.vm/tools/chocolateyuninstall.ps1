$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Windows Terminal'
$category = 'Productivity Tools'

# Let Windows decide what is the default terminal
$registryPath = 'HKCU:\Console\%%Startup'
New-Item $registryPath -Force | Out-Null
Set-ItemProperty $registryPath -Name "DelegationConsole" -Value "{00000000-0000-0000-0000-000000000000}" -Force | Out-Null
Set-ItemProperty $registryPath -Name "DelegationTerminal" -Value "{00000000-0000-0000-0000-000000000000}" -Force | Out-Null

VM-Uninstall $toolName $category
VM-Remove-From-Right-Click-Menu -menuKey $toolName -type "directory" -background
