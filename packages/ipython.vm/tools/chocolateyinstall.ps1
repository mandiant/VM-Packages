$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ipython'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==8.27.0'

VM-Install-With-Pip -toolName $toolName -category $category -arguments "" -version $version
