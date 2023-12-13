$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Kernel Outlook PST Viewer'
$category = 'Forensic'

VM-Uninstall $toolName $category
