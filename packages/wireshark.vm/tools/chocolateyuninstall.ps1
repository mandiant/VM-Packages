$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolNames = @('Wireshark', 'tshark')
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

ForEach ($toolName in $toolNames) {
  VM-Remove-Tool-Shortcut $toolName $category
}
