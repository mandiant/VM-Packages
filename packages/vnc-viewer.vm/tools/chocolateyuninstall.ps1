$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VNC-Viewer'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName $category
