$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pe-sieve'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Remove-Tool-Shortcut $toolName $category
