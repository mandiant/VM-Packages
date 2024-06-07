$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = 'File Information'

VM-Install-With-Pip -toolName $toolName -category $category
