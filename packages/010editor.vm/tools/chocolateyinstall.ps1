$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

# a change here, should be yelled at by the linter

try {
  $toolName = '010Editor'
  $category = 'Hex Editors'

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer12.0.1.exe'
  $checksum = '7790f48716c728e45989375d2b4d2deaa611d39c40e93ba470651bdc44305434'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer12.0.1.exe'
  $checksum64 = '65c2999e430e026a5906b9a7064f8d9a56e798284309efde7140a515237b9dae'

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
