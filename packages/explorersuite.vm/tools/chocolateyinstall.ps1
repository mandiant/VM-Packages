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

  $cffExecutablePath = Join-Path $toolDir 'CFF Explorer.exe' -Resolve
  Install-BinFile -Name 'CFFExplorer' -Path $cffExecutablePath

  # Installing CFF Explorer adds it to the right click menu for several file extensions (without icon)
  # Delete the registry subkeys for the concrete file extensions to ensure the one we create (with icon) for all extensions applies
  Remove-Item -Path "HKLM:\SOFTWARE\Classes\*file\shell\Open with CFF Explorer" -Recurse

  VM-Add-To-Right-Click-Menu 'Open with CFF Explorer' 'Open with CFF Explorer' "`"$cffExecutablePath`" %1" $cffExecutablePath

  # Refresh Desktop as CFF Explorer shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
