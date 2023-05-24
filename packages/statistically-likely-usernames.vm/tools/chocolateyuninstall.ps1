$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Statistically-Likely-Usernames'
$category = 'Wordlists'

VM-Uninstall $toolName $category
