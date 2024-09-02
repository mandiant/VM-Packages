$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = 'Utilities'

VM-Uninstall $toolName $category
Unregister-ScheduledTask -TaskName 'Internet Detector' -Confirm:$false
