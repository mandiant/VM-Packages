$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pyghidra'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==2.2.0'
$arguments = ''

VM-Install-With-Pip -toolName $toolName -category $category -version $version -arguments $arguments
