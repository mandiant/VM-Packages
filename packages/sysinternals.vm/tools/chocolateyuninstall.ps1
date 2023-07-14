$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'sysinternals'

# Remove our shims
Get-ChildItem -Path "$toolDir\*" -Include '*.exe' | ForEach-Object { Uninstall-BinFile -Name $([System.IO.Path]::GetFileNameWithoutExtension($_)) -ea 0 }

###
# First category
$category = 'Utilities'
VM-Remove-Tool-Shortcut 'sysinternals' $category
VM-Remove-Tool-Shortcut 'procexp' $category
VM-Remove-Tool-Shortcut 'procmon' $category

###
# Second category
$category = 'Reconnaissance'
VM-Remove-Tool-Shortcut 'ADExplorer' $category

###
# Restore dependency's tools
# Location of dependency's tools (all sysinternal tools)
$chocoToolDir = Join-Path ${Env:ChocolateyInstall} 'lib\sysinternals\tools'

# Move items back to original location
Get-ChildItem -Path "$toolDir\*" -Exclude '*.ps1' | Move-Item -Destination $chocoToolDir -Force -ea 0

# Re-establish old shims
Get-ChildItem -Path "$chocoToolDir\*" -Include '*.exe' | ForEach-Object { Install-BinFile -Name $([System.IO.Path]::GetFileNameWithoutExtension($_)) -Path $_.FullName -ea 0 }

###
# Remove tool directory
Remove-Item $toolDir -Recurse -Force -ea 0