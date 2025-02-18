$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'magika'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = "==0.5.0"

VM-Install-With-Pip -toolName $toolName -category $category -version $version