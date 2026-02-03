$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = '010Editor'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $url   = 'https://download.sweetscape.com/010EditorWin32Installer16.0.3.exe'
  $checksum = 'd6b5f5abf50dd22fd5012dba2d16ef9f334d3aae49972333ae50bb983da41406'
  $url64 = 'https://download.sweetscape.com/010EditorWin64Installer16.0.3.exe'
  $checksum64 = 'bfb77fd3e4a64cda7ccc9aef3ec968490be8b77a9ec4b7f273152072b103b28a'

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
