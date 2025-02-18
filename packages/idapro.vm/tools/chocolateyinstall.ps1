$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'ida'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $installerPaths = Resolve-Path "${Env:USERPROFILE}\Desktop\ida-pro_9*.exe"
  if ($installerPaths.count -eq 0) {
    throw "An IDA Pro installer 'ida-pro_9*.exe' in the Desktop is required. Get your installer from https://hex-rays.com/ida-pro"
  }
  elseif ($installerPaths.count -gt 1) {
    # Only one installer supported (prospective change)
    throw "Several IDA Pro installers found in Desktop, only 1 installer is supported."
  }
  $installerPath = $installerPaths | Select-Object -first 1
  VM-Write-Log "INFO" "Installing IDA Pro: $installerPath"

  # Run installer
  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    file           = $installerPath
    fileType       = 'exe'
    # unclear what the required argument `--install_python` expects
    silentArgs     = '--mode unattended --install_python flare'
  }
  Install-ChocolateyInstallPackage @packageArgs | Out-Null

  # Wait for IDA to be installed
  Start-Sleep -Seconds 10
  $executablePath = Resolve-Path "${Env:ProgramFiles}\IDA Professional 9*\ida.exe"
  VM-Assert-Path $executablePath

  Install-BinFile -Name $toolname -Path $executablePath

  # Delete "IDA Teams Visual Client" Desktop shortcut
  # Do not delete "IDA Professional 9.0", as it is useful to drag binaries to it
  $desktopShortcut = Resolve-Path "${Env:Public}\Desktop\IDA Teams Visual Client*"
  if ($null -ne $desktopShortcut) { Remove-Item $desktopShortcut -Force -ea 0 }

  # Add ida to the Tools directory, use directly (instead of ida_launcher.exe) to avoid taskbar duplication
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath

  # Download ida_launcher.exe and store it in %RAW_TOOLS_DIR%
  # ida_launcher.exe is a custom binary that searches for the latest ida64.exe and executes it
  $launcherName = 'ida_launcher'
  $launcherSource = 'https://raw.githubusercontent.com/mandiant/VM-Packages/119ba385de053b01b0d1732d60ad1b1152496dc2/ida_launcher/ida_launcher.exe'
  $launcherPath = Join-Path ${Env:RAW_TOOLS_DIR} "$launcherName.exe"
  $launcherChecksum = "a98241e476150d053d67d149c1b54816c8306db51e0987613ec25a0f8ad22006"
  Get-ChocolateyWebFile -PackageName $launcherName -FileFullPath $launcherPath -Url $launcherSource -Checksum $launcherChecksum -ChecksumType "sha256"
  VM-Assert-Path $launcherPath

  # Use ida_launcher.exe in the right click option "Open with IDA"
  $icon = Resolve-Path "${Env:ProgramFiles}\IDA*\$toolName.ico" | Select-Object -last 1
  VM-Add-To-Right-Click-Menu $launcherName 'Open with IDA' "`"$launcherPath`" `"%1`"" "$icon"


  # Create IDA user directory (also if no license file is copied as it makes it easier to manually add the license file)
  $idaDir = "${Env:APPDATA}\Hex-Rays\IDA Pro"
  New-Item $idaDir -ItemType "directory" -Force | Out-Null

  # Copy license file to IDA user directory if present in Desktop
  $licensePaths = Resolve-Path "${Env:USERPROFILE}\Desktop\idapro_9*.hexlic"
  if ($licensePaths.count -eq 0) {
    VM-Write-Log "WARN" "No IDA Pro license file 'idapro_9*.hexlic' found in Desktop."
    VM-Write-Log "WARN" "Get your license file from https://hex-rays.com/ida-pro and copy it to IDA user directory before launching IDA Pro."
  }
  else {
    # Copy license file(s)
    ForEach ($licensePath in $licensePaths) {
      VM-Write-Log "INFO" "Copying license file to IDA user directory: $licensePath"
      Copy-Item $licensePath $idaDir
    }
  }

  # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
