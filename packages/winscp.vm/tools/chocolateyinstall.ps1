$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'WinSCP'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ProgramFiles(x86)} "$toolName\$toolName.exe" -Resolve
  Install-BinFile -Name $toolName -Path $executablePath

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\$toolName.lnk"
  Remove-Item $desktopShortcut -Force -ea 0
} catch {
  VM-Write-Log-Exception $_
}
