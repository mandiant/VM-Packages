$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Putty'
  $category = 'Utilities'

  $url   = 'https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.77-installer.msi'
  $checksum = '8ECE5F9D805FCF1D790F5E148D2A248DEA4813024659EB6C6468B47004BC805F'

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

} catch {
  VM-Write-Log-Exception $_
}
