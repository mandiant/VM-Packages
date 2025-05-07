$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'suricata'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Uninstaller $toolName $category "MSI" "/qn /norestart"