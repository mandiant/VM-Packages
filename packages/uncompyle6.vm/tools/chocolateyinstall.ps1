$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uncompyle6'
$category = 'Python'
$version = '==3.9.2'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
