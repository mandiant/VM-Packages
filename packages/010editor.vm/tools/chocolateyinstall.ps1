$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer15.0.2.exe'
  $checksum = '143b2057f2eb666cf744e0b1775a55e57ba3db59ba48a009864845bb21768e63'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer15.0.2.exe'
  $checksum64 = 'a83418fe72dfa758ac8e0331d03e735697de7feb36d93dc14234dda3bf58e488'

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
