$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = "==1.0.2"

VM-Install-With-Pip -toolName $toolName -category $category -version $version