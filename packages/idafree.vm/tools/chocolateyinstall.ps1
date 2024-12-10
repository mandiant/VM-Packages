$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'idafree'
  $category = 'Disassemblers'

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '--mode unattended'
    url          = 'https://out7.hex-rays.com/files/idafree84_windows.exe'
    checksum     = 'a2fc7eae91860a6d05c946d1ee8ab59afd061e8fc5f965de4112d66b16ac2091'
    checksumType = 'sha256'
  }
  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} "IDA Freeware 8.4" -Resolve
  $executablePath = Join-Path $toolDir "ida64.exe" -Resolve

  Install-BinFile -Name $toolname -Path $executablePath

  # Delete Desktop shortcut
  $desktopShortcut = Join-Path ${Env:Public} "Desktop\IDA Freeware 8.4.lnk"
  if (Test-Path $desktopShortcut) {
    Remove-Item $desktopShortcut -Force -ea 0
  }

  # Download ida_launcher.exe to assist with taskbar and right click option and store it in %RAW_TOOLS_DIR%
  # ida_launcher.exe is a custom binary that searches for the latest ida64.exe and executes it
  $launcherName = 'ida_launcher'
  $launcherSource = 'https://raw.githubusercontent.com/mandiant/VM-Packages/119ba385de053b01b0d1732d60ad1b1152496dc2/ida_launcher/ida_launcher.exe'
  $launcherPath = Join-Path ${Env:RAW_TOOLS_DIR} "$launcherName.exe"
  $launcherChecksum = "a98241e476150d053d67d149c1b54816c8306db51e0987613ec25a0f8ad22006"
  Write-Host "[+] Downloading '$launcherSource'"
  Get-ChocolateyWebFile -PackageName $launcherName -FileFullPath $launcherPath -Url $launcherSource -Checksum $launcherChecksum -ChecksumType "sha256"

  VM-Assert-Path $launcherPath

  $menuIcon = Join-Path $toolDir "ida.ico" -Resolve

  VM-Install-Shortcut -toolName "ida" -category $category -executablePath $launcherPath -IconLocation $menuIcon

  # ida64.exe supports both 32 bit and 64 bit in IDA >= 8.2
  VM-Add-To-Right-Click-Menu $launcherName 'Open with IDA' "`"$launcherPath`" `"%1`"" "$menuIcon"
} catch {
  VM-Write-Log-Exception $_
}
