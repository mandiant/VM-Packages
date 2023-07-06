$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = 'Hex Editors'

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer13.0.1.exe'
  $checksum = '832f548a0a8850d353e3fc67d7c65301883f07f035131aa77d3144653a4c40e5'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer13.0.1.exe'
  $checksum64 = '4c55d604397db9789b0eb39042707cbcf0bd36d5b43910f47462955b2b53332f'

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
