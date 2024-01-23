$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'x64dbg'
  $category = 'Debuggers'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName
  $snapshotDate = '2024-01-06_21-29'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = "https://sourceforge.net/projects/x64dbg/files/snapshots/snapshot_$snapshotDate.zip"
    checksum      = '467e41d68e489aad288cb0d868ea37ceb9dcda3757d9badc6314964d847e26b4'
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
