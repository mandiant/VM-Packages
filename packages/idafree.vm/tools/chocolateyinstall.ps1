$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'idafree'
  $category = 'Disassemblers'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '--mode unattended'
    url          = 'https://out7.hex-rays.com/files/idafree76_windows.exe'
    checksum     = '2ecc5b2f5329c4e7a4243634801180be38a397c31a330324c8abc605f5dffb9e'
    checksumType = 'sha256'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 7.6" -Resolve
  $executablePath = Join-Path $toolDir "ida64.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "$toolname.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut

  Install-BinFile -Name $toolname -Path $executablePath

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\IDA Freeware 7.6.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }
} catch {
  VM-Write-Log-Exception $_
}
