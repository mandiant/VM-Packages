$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
Disable-ScheduledTask -TaskName 'Internet Detector' -ea 0 | ForEach-Object {
    $_ | Stop-ScheduledTask
    $_ | Unregister-ScheduledTask -Confirm:$false
}
Stop-Process -Name "$toolName.exe" -Force -ea 0
