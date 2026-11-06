$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'angr'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==10.0.5'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
