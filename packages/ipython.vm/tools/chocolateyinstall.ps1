$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ipython'
$category = 'Productivity Tools'
$version = '==8.27.0'

VM-Install-With-Pip -toolName $toolName -category $category -arguments "" -version $version
