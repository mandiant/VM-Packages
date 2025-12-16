$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'poetry'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==2.2.1'
$arguments = ''

VM-Install-With-Pip -toolName $toolName -category $category -version $version -arguments $arguments
