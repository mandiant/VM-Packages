$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'ProcessHacker'
  $category = 'Utilities'

  $url   = 'https://versaweb.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe'
  $checksum = '28042DD4A92A0033B8F1D419B9E989C5B8E32D1D2D881F5C8251D58CE35B9063'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    checksumType  = 'sha256'
    checksum      = $checksum
    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOICONS'
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
  $shortcut_desktop = Join-Path ${Env:UserProfile} "Desktop\Process Hacker 2.lnk"
  if (Test-Path $shortcut_desktop) {
    Remove-Item $shortcut_desktop -Force -ea 0 | Out-Null
  }
} catch {
  VM-Write-Log-Exception $_
}
