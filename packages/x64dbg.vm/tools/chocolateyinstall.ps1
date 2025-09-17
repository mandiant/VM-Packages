$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolName = 'x64dbg'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = "https://github.com/x64dbg/x64dbg/releases/download/2025.08.19/snapshot_2025-08-19_19-40.zip"
    checksum      = 'cc614caf34f9fe1ec156f045129db3a513c35593ff1ee647bc819a352dc12271'
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
