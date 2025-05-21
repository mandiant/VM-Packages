$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'angr'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==9.2.157'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
