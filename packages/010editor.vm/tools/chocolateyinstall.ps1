$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = 'Hex Editors'

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer15.0.exe'
  $checksum = '20bb9534385c09e962da5f8653e6121368b1a330b1cd5e135d4afe39eab714eb'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer15.0.exe'
  $checksum64 = 'a39860c150cc65399379a9072220eed0870b6a753a4fbaafd6c0741291a6490b'

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
