$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'sfextract'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

dotnet tool uninstall --global sfextract

VM-Remove-Tool-Shortcut $toolName $category
