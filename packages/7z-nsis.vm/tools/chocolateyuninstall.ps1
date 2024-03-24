$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = '7z'
$category = 'Productivity Tools'

VM-Uninstall $toolName $category

# Remove binary from PATH
Uninstall-BinFile -Name $toolName

$extensions = @(".7z", ".bzip2", ".gzip", ".tar", ".wim", ".xz", ".txz", ".zip", ".rar")
foreach ($extension in $extensions) {
  VM-Remove-From-Right-Click-Menu $toolName -extension $extension
}
