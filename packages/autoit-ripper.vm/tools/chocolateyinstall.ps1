$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'autoit-ripper'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==1.1.2'

VM-Install-With-Pip -toolName $toolName -category $category -version $version
