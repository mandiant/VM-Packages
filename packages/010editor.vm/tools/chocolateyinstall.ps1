$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = 'Hex Editors'

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer14.0.exe'
  $checksum = '11d96fa10df0f8e6add3509e03b963c398a190890f0ea45d8e56c4dd77cbeaa9'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer14.0.exe'
  $checksum64 = '9f926af3bc49df3ab3b2fa8e9cf97caf018081df277c25ee37fab8c2fdd974ba'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    url64bit      = $url64
    checksumType  = 'sha256'
    checksum      = $checksum
    checksum64    = $checksum64
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOICONS /MERGETASKS="!desktopicon"'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} '010 Editor' -Resolve
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"

  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
  VM-Assert-Path $shortcut

  Install-BinFile -Name $toolName -Path $executablePath
} catch {
  VM-Write-Log-Exception $_
}
