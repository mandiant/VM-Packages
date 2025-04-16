$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

Disable-ScheduledTask -TaskName 'Internet Detector' -ea 0 | ForEach-Object {
    $_ | Stop-ScheduledTask
    $_ | Unregister-ScheduledTask -Confirm:$false
}
Stop-Process -Name "$toolName.exe" -Force -ea 0
VM-Uninstall $toolName $category

$fakenetConfig = "$Env:RAW_TOOLS_DIR\fakenet\fakenet3.5\configs\default.ini"
$config = Get-Content -Path $fakenetConfig
$config = $config -replace '^.*BlackListIDsICMP.*$', "# BlackListIDsICMP: 1234"
Set-Content -Path $fakenetConfig -Value $config -Encoding ASCII -Force
