$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'keystone-engine'
$version = '==0.9.2'

VM-Pip-Install $toolName$version
