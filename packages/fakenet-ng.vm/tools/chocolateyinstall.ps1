$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  # We do not use the VM-Install-From-Zip because the shortcut executable has to be run from the tools dir:
  # https://github.com/mandiant/flare-fakenet-ng/issues/180
  $toolName = 'fakenet'
  $category = 'Networking'

  $zipUrl = "https://github.com/mandiant/flare-fakenet-ng/releases/download/v3.2-alpha/fakenet3.2-alpha.zip"
  $zipSha256 = "5941a0401830c2310226f0cd2d640e091f1c8bf1b93c5288e6626eecebf20bff"

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
  $dirList = Get-ChildItem $toolDir -Directory
  $toolDir = Join-Path $toolDir $dirList[0].Name -Resolve

  $executablePath = Join-Path $toolDir "$toolName.exe" -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -executableDir $toolDir -consoleApp $true
  Install-BinFile -Name $toolName -Path $executablePath

  # Create shortcut in Desktop to FakeNet tool directory
  $desktopShortcut  = Join-Path ${Env:UserProfile} "Desktop\fakenet_logs.lnk"
  Install-ChocolateyShortcut -shortcutFilePath $desktopShortcut -targetPath $toolDir
  VM-Assert-Path $desktopShortcut
} catch {
  VM-Write-Log-Exception $_
}
