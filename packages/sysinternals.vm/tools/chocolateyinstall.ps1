$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# Note: This package depends on the package 'sysinternals' that installs multiple tools.
#       We're moving these tools to a centeralized location and linking them under
#       multiple different categories: Utilities, Active Directory Tools

try {
  # Create directory to store tools
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'sysinternals'
  if (-Not (Test-Path -Path $toolDir) ) {
    New-Item -Path $toolDir -ItemType Directory -Force | Out-Null
  }

  # Location of dependency's tools (all sysinternal tools)
  $chocoToolDir = Join-Path ${Env:ChocolateyInstall} 'lib\sysinternals\tools' -Resolve

  # Remove previous shims
  Get-ChildItem -Path "$chocoToolDir\*" -Include '*.exe' | ForEach-Object { Uninstall-BinFile -Name $([System.IO.Path]::GetFileNameWithoutExtension($_)) -ea 0 }

  # Move items to new location
  Get-ChildItem -Path "$chocoToolDir\*" -Exclude '*.ps1' | Move-Item -Destination $toolDir -Force -ea 0

  # Re-shim moved items
  Get-ChildItem -Path "$toolDir\*" -Include '*.exe' | ForEach-Object { Install-BinFile -Name $([System.IO.Path]::GetFileNameWithoutExtension($_)) -Path $_.FullName -ea 0 }

  ###
  # First category
  $category = 'Utilities'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  # Add shortcut to sysinternals folder
  $shortcut = Join-Path $shortcutDir 'sysinternals.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $toolDir
  VM-Assert-Path $shortcut

  # Add shortcut for commonly used tool (procexp)
  $executablePath = Join-Path $toolDir 'procexp.exe' -Resolve
  $shortcut = Join-Path $shortcutDir 'procexp.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Add shortcut for commonly used tool (procmon)
  $executablePath = Join-Path $toolDir 'procmon.exe'
  $shortcut = Join-Path $shortcutDir 'procmon.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  ###
  # Second category
  $category = 'Reconnaissance'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $executablePath = Join-Path $toolDir 'ADExplorer.exe' -Resolve
  $shortcut = Join-Path $shortcutDir 'ADExplorer.lnk'
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}