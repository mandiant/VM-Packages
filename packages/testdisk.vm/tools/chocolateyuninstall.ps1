$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'TestDisk'
$category = 'Forensic'

$subToolNames = 'testdisk', 'photorec', 'qphotorec', 'fidentify'
foreach ($subToolName in $subToolNames) {
  VM-Remove-Tool-Shortcut $subToolName $category
}

VM-Uninstall $toolName $category
