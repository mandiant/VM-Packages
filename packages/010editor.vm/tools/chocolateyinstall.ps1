$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = 'Hex Editors'

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer13.0.2.exe'
  $checksum = '30f21ab0d744b37951b7406aee84d7e2f236d4e2d1e7dcf50d750638408461b2'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer13.0.2.exe'
  $checksum64 = 'c85695071e530d1bc86d116fe8f674d1089ae222659055bafab650280427a1ee'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    url64bit      = $url64
    checksumType  = 'sha256'
    checksum      = $checksum
    checksum64    = $checksum64
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOICONS'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} '010 Editor' -Resolve
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut

  Install-BinFile -Name $toolName -Path $executablePath

  # Delete Desktop shortcut
  $shortcut_desktop = Join-Path ${Env:UserProfile} "Desktop\010 Editor.lnk"
  if (Test-Path $shortcut_desktop) {
    Remove-Item $shortcut_desktop -Force -ea 0 | Out-Null
  }
} catch {
  VM-Write-Log-Exception $_
}
