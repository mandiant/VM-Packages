$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ipython'
$category = 'Productivity Tools'

VM-Install-With-Pip -toolName $toolName -category $category -arguments ""
