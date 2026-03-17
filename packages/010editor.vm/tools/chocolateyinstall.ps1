$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer16.0.4.exe'
  $checksum = '94da8548468989127db0f5e6072bb5640bed155b12b29d7402c5f89e05ed049d'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer16.0.4.exe'
  $checksum64 = '36bae5d17aac1919ac3b66ce22954794b36a058b459290440a7fed9ff2b379be'

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
