$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'x64dbg'
  $category = 'Debuggers'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = "https://sourceforge.net/projects/x64dbg/files/snapshots/snapshot_2024-04-11_18-47.zip/download"
    checksum      = 'bbfcd9b0776415394fa3529eab262de0b2c55d816133ff5910e87c6d8b1fde44'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $executablePath = Join-Path $toolDir "release\x32\x32dbg.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "x32dbg.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  Install-BinFile -Name 'x32dbg' -Path $executablePath

  $executablePath = Join-Path $toolDir "release\x64\x64dbg.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "x64dbg.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  Install-BinFile -Name 'x64dbg' -Path $executablePath
} catch {
  VM-Write-Log-Exception $_
}
