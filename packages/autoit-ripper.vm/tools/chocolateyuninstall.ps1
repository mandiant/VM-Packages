$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'autoit-ripper'
$category = 'Packers'

VM-Uninstall-With-Pip -toolName $toolName -category $category
