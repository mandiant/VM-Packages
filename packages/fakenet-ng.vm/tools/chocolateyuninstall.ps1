$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'fakenet'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall $toolName $category

# Remove Desktop shortcut to FakeNet tool directory
$desktopShortcut  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
Remove-Item $desktopShortcut -Force -ea 0

# Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
VM-Refresh-Desktop
