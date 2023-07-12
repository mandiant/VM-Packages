$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MailSniper'
$category = 'Credential Access'

VM-Uninstall $toolName $category
