$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'nasm'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\$toolName.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executableDir = Join-Path ${Env:ProgramFiles} 'NASM' -Resolve
  $batPath = Join-Path $executableDir 'nasmpath.bat' -Resolve
  $iconPath = Join-Path $executableDir 'nasm.ico' -Resolve
  # Create shortcut in a similar way than the deleted Desktop shortcut
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $batPath -WorkingDirectory $executableDir -IconLocation $iconPath
  VM-Assert-Path $shortcut

  $executablePath = Join-Path $executableDir 'nasm.exe' -Resolve
  Install-BinFile -Name $toolName -Path $executablePath
} catch {
  VM-Write-Log-Exception $_
}
