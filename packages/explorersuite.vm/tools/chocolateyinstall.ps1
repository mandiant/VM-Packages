$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $category = 'PE'

  $url = "https://ntcore.com/files/ExplorerSuite.exe"

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'Explorer Suite'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    fileType      = 'EXE'
    url           = $url
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /DIR=`"$toolDir`""
  }
  Install-ChocolateyPackage @packageArgs
  VM-Assert-Path $toolDir

  $subtoolNames = 'CFF Explorer', 'PE Detective', 'Task Explorer', 'Task Explorer-x64'
  foreach ($subtoolName in $subtoolNames) {
    $executablePath = Join-Path $toolDir "$subtoolName.exe" -Resolve
    $shortcut = Join-Path $shortcutDir "$subtoolName.lnk"
    Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath
    VM-Assert-Path $shortcut
  }

  $cffExplorerExecutablePath = Join-Path $toolDir 'CFF Explorer.exe' -Resolve
  Install-BinFile -Name 'CFFExplorer' -Path $cffExplorerExecutablePath
  # "Open with CFF Explorer" is added to the registry for several extensions,
  # add it for all extension with same key to avoid duplication.
  # Use same label and no icon to make it look the same for all extensions.
  VM-Add-To-Right-Click-Menu 'Open with CFF Explorer' 'Open with CFF Explorer' "`"$cffExplorerExecutablePath`" %1"
} catch {
  VM-Write-Log-Exception $_
}
