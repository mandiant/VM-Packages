$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JuicyPotato'
$category = 'Privilege Escalation'

VM-Uninstall $toolName $category
