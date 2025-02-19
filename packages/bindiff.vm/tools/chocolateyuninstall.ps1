$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BinDiff'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Uninstall-With-Uninstaller -toolName $toolName -category $category -fileType "MSI" -silentArgs '/qn /norestart'
