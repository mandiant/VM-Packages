$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # We do not use the VM-Install-From-Zip because the shortcut executable has to be run from the tools dir:
  # https://github.com/mandiant/flare-fakenet-ng/issues/180
  $toolName = 'fakenet'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $zipUrl = "https://github.com/mandiant/flare-fakenet-ng/releases/download/v3.5/fakenet3.5.zip"
  $zipSha256 = "89d85290a570ef509b40137b6cf61895da1cebfe8b5cbe2882639461149ef7bc"

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  # Download and unzip
  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = $zipUrl
    checksum      = $zipSha256
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs | Out-Null
  VM-Assert-Path $toolDir

  # There is an inner folder in the zip whose name changes as it includes the version
  # Select the latest fakenet version to prevent conflict with older installed versions
  $dirList = Get-ChildItem $toolDir -Directory
  $toolDir = Join-Path $toolDir $dirList[-1].Name -Resolve

  $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -executableDir $toolDir
  Install-BinFile -Name $toolName -Path $executablePath

  # Create shortcut in Desktop to FakeNet tool directory
  $desktopShortcut  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $desktopShortcut -targetPath $toolDir
  VM-Assert-Path $desktopShortcut

  # Refresh Desktop as shortcut is used in FLARE-VM LayoutModification.xml
  VM-Refresh-Desktop
} catch {
  VM-Write-Log-Exception $_
}
