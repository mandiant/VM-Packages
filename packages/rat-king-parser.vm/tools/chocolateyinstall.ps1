$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'rat-king-parser'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==4.0.1'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
