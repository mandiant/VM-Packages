$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'sfextract'
$category = 'dotNet'

dotnet tool uninstall --global sfextract

VM-Remove-Tool-Shortcut $toolName $category
