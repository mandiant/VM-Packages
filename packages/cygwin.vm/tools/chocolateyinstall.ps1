﻿$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'cygwin'
  $category = 'Productivity Tools'

  # install additional cygwin packages
  $packages = @(
    "xxd",
    "cygstart",
    "openssh",
    "wget", "curl",
    "vim", "vim-common",
    "tar", "bzip2",
    "bash-completion",
    "rsync",
    "diffutils", "patchutils"
  )
  foreach ($pkg in $packages) {
    try {
      Invoke-Expression "choco install $pkg -y --source cygwin"
    } catch {
        VM-Write-Log "ERROR" "$_.Exception.Message`r`n$_.InvocationInfo.PositionMessage"
    }
  }

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} "Cygwin" -Resolve
  $toolBin = Join-Path $toolDir "bin" -Resolve
  $executablePath = Join-Path $toolBin "mintty.exe" -Resolve
  $executableArgs = "-"

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -Arguments $executableArgs
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
