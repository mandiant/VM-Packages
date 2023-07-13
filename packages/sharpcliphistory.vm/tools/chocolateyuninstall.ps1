$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpClipHistory'
$category = 'Credential Access'

VM-Uninstall $toolName $category
