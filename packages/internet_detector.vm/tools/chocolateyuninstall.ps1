$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'internet_detector'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category
Unregister-ScheduledTask -TaskName 'Internet Detector' -Confirm:$false

$fakenetConfig = "$Env:RAW_TOOLS_DIR\fakenet\fakenet3.5\configs\default.ini"
$config = Get-Content -Path $fakenetConfig
$config = $config -replace '^.*BlackListIDsICMP.*$', "# BlackListIDsICMP: 1234"
Set-Content -Path $fakenetConfig -Value $config -Encoding UTF8 -Force
