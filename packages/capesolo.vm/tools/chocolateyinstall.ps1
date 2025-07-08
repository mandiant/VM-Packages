$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CAPEsolo'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==0.4.23'

VM-Install-With-Pip -toolName $toolName -category $category -version $version -arguments ""
