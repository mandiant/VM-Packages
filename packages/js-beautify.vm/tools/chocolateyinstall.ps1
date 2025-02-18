$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'js-beautify'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Install-Node-Tool -toolName $toolName -category $category -arguments "--help"
