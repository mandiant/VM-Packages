$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'idafree'
  $category = 'Disassemblers'
  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '--mode unattended'
    url          = 'https://out7.hex-rays.com/files/idafree83_windows.exe'
    checksum     = '10080a057704630578e697c6bb0b09968a54138075cacab175f62d60c71d0a1f'
    checksumType = 'sha256'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 8.3" -Resolve
  $executablePath = Join-Path $toolDir "ida64.exe" -Resolve

  Install-BinFile -Name $toolname -Path $executablePath

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\IDA Freeware 8.3.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }

  # Download ida_launcher.exe to assist with taskbar and right click option and store it in %RAW_TOOLS_DIR%
  # ida_launcher.exe is a custom binary that searches for the latest ida64.exe and executes it
  $launcherName = 'ida_launcher'
  $launcherSource = 'https://raw.githubusercontent.com/mandiant/VM-Packages/773649e54aaea62f270c8416cb480020d6475065/ida_launcher/ida_launcher.exe'
  $launcherPath = Join-Path ${Env:RAW_TOOLS_DIR} "$launcherName.exe"
  $launcherChecksum = "ebebf8cf01253aab0562b42128f08fdb9b4452f1f49847c51673e5610063a8b5"
  Write-Host "[+] Downloading '$launcherSource'"
  Get-ChocolateyWebFile -PackageName $launcherName -FileFullPath $launcherPath -Url $launcherSource -Checksum $launcherChecksum -ChecksumType "sha256"

  VM-Assert-Path $launcherPath

  $launcherShortcut = Join-Path $shortcutDir "ida.lnk"
  $menuIcon = Join-Path $toolDir "ida.ico" -Resolve

  Install-ChocolateyShortcut -shortcutFilePath $launcherShortcut -targetPath $launcherPath -IconLocation $menuIcon

  # ida64.exe supports both 32 bit and 64 bit in IDA >= 8.2
  VM-Add-To-Right-Click-Menu $launcherName 'Open with IDA' "`"$launcherPath`" `"%1`"" "$menuIcon"
} catch {
  VM-Write-Log-Exception $_
}
