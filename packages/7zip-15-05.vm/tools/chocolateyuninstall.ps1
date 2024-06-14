$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '7z'
$category = 'Productivity Tools'

VM-Uninstall $toolName $category

# Manually silently uninstall
VM-Uninstall-With-Uninstaller "7-Zip 15.05*" $category "EXE" "/S"

$extensions = @(".7z", ".bzip2", ".gzip", ".tar", ".wim", ".xz", ".txz", ".zip", ".rar")
foreach ($extension in $extensions) {
  VM-Remove-From-Right-Click-Menu $toolName -extension $extension
  VM-Remove-Open-With-Association "${toolName}FM" -extension $extension
}
