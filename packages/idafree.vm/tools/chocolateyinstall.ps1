$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'ida'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  # Download IDA .7z with the IDA installer and the FLARE-VM license
  $idaZipPath = Join-Path ${Env:TEMP} "ida_installer.7z"
  $idaZipSource = "https://hex-rays.com/hubfs/FlareVM/ida_installer.7z"
  $idaZipChecksum = "d5e463cb13359707303442e16408351af7cff08f2b51ed12cacb7b5ddda0d165"
  Get-ChocolateyWebFile -PackageName $toolName -fileFullPath $idaZipPath -Url $idaZipSource -Checksum $idaZipChecksum -ChecksumType "sha256"
  VM-Assert-Path $idaZipPath

  # Unzip downloaded .7z with the IDA installer and the FLARE-VM license
  $idaUnzippedDir = Join-Path ${Env:TEMP} $toolName
  7z x $idaZipPath -o"$idaUnzippedDir" -y -bd | Out-Null

  $installerPath = Get-ChildItem -Path  "$idaUnzippedDir\ida-free-*.exe"
  VM-Assert-Path $installerPath

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '--mode unattended'
    file         = $installerPath
  }
  Install-ChocolateyPackage @packageArgs

  # Wait for IDA to be installed
  Start-Sleep -Seconds 10

  $toolDir = Get-ChildItem -Path "${Env:ProgramFiles}\IDA Free*" -Directory
  $executablePath = Join-Path $toolDir "ida.exe" -Resolve

  Install-BinFile -Name $toolname -Path $executablePath

  # Add ida to the Tools directory, use directly (instead of ida_launcher.exe) to avoid taskbar duplication
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath

  # Download ida_launcher.exe to assist with taskbar and right click option and store it in %RAW_TOOLS_DIR%
  # ida_launcher.exe is a custom binary that searches for the latest ida64.exe and executes it
  $launcherName = 'ida_launcher'
  $launcherSource = 'https://github.com/mandiant/VM-Packages/raw/ab43abbebf0f58abf579775e0794c2888285dee1/ida_launcher/ida_launcher.exe'
  $launcherPath = Join-Path ${Env:RAW_TOOLS_DIR} "$launcherName.exe"
  $launcherChecksum = "e6d6799254985a4db1098806515a9bcf4b818bde246d37839769874ecf7a2a84"
  Get-ChocolateyWebFile -PackageName $launcherName -FileFullPath $launcherPath -Url $launcherSource -Checksum $launcherChecksum -ChecksumType "sha256"
  VM-Assert-Path $launcherPath

  # Use ida_launcher.exe in the right click option "Open with IDA"
  $icon = Join-Path $toolDir "ida.ico" -Resolve
  VM-Add-To-Right-Click-Menu $launcherName 'Open with IDA' "`"$launcherPath`" `"%1`"" "$icon"

  # Create IDA user directory and copy flare-vm@google.com license
  $idaDir = "${Env:APPDATA}\Hex-Rays\IDA Pro"
  New-Item $idaDir -ItemType "directory" -Force | Out-Null
  $licensePath = Get-ChildItem -Path "$idaUnzippedDir\idafree_9*.hexlic"
  Copy-Item $licensePath $idaDir

  # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
