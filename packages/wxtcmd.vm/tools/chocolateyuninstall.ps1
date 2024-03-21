$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WxTCmd'
$category = 'Forensic'

VM-Uninstall $toolName $category
