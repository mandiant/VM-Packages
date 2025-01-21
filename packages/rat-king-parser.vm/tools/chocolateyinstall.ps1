$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'rat-king-parser'
$category = 'Utilities'
$version = '==4.0.1'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
