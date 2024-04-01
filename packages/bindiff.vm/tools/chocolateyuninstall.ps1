$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BinDiff'
$category = 'File Information'

VM-Uninstall-With-Uninstaller -toolName $toolName -category $category -fileType "MSI" -silentArgs '/qn /norestart'
