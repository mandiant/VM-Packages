$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolNames = @('Wireshark', 'tshark')
$category = 'Networking'

ForEach ($toolName in $toolNames) {
  VM-Remove-Tool-Shortcut $toolName $category
}
