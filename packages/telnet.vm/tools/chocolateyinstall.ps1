$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'telnet'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $system32=Join-Path $Env:WINDIR system32
  $pkgmgr= Join-Path $system32 "pkgmgr.exe"
  $rc = (Start-Process -FilePath $pkgmgr -Argumentlist '/iu:"TelnetClient"' -PassThru -Wait).ExitCode
  if ($rc -ne 0) {
    throw "PkgMgr returned error code $rc"
  } else {
    VM-Assert-Path $(Join-Path $system32 "telnet.exe")
  }

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path $system32 "telnet.exe" -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut
} catch {
  VM-Write-Log-Exception $_
}
