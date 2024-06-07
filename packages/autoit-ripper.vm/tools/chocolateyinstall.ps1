$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'autoit-ripper'
$category = 'Packers'

VM-Install-With-Pip -toolName $toolName -category $category
