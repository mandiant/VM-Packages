$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'VLC'
  $category = 'Utilities'

  $url   = 'https://plug-mirror.rcac.purdue.edu/vlc/vlc/3.0.17.4/win32/vlc-3.0.17.4-win32.msi'
  $checksum = 'a8067928fbd2eed35e7eedb19d8c867e58e79a9bd1f92d1b3339151ecd5a4779'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    checksumType  = 'sha256'
    checksum      = $checksum
    silentArgs    = '/QUIET /PASSIVE'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} $toolName -Resolve
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut

  Install-BinFile -Name $toolName -Path $executablePath

  # Delete Desktop shortcut
  $shortcut_desktop = Join-Path ${Env:UserProfile} "Desktop\VLC media player.lnk"
  if (Test-Path $shortcut_desktop) {
    Remove-Item $shortcut_desktop -Force -ea 0 | Out-Null
  }

} catch {
  VM-Write-Log-Exception $_
}
