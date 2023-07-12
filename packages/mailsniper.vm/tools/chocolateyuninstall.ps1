$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MailSniper.ps1'
$category = 'Credential Access'

VM-Uninstall $toolName $category
