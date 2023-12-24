$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "XMLTools"
  $pluginsDir = Join-Path ${Env:ProgramFiles} "Notepad++\plugins" -Resolve
  $toolDir = New-Item (Join-Path $pluginsDir $toolName) -itemtype directory
  VM-Assert-Path $toolDir

  $zipUrl= "https://github.com/morbac/xmltools/releases/download/3.1.1.13/XMLTools-3.1.1.13-x86.zip"
  $zipSha256 = "9521d91be847a9c9fcfc6cb6ea5455fd7dfe840f4f12a8fd95e5137116dbd6c3"
  $zipUrl_64 = "https://github.com/morbac/xmltools/releases/download/3.1.1.13/XMLTools-3.1.1.13-x64.zip"
  $zipSha256_64 ="7631ea990e731172e28e9fe85ac4861185c0292143603b9486bc969cc8e8e046"

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  # Download and unzip
  $packageArgs = @{
    packageName    = ${Env:ChocolateyPackageName}
    unzipLocation  = $toolDir
    url            = $zipUrl
    checksum       = $zipSha256
    checksumType   = 'sha256'
    url64bit       = $zipUrl_64
    checksum64     = $zipSha256_64
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path (Join-Path $toolDir "$toolName.dll")
} catch {
  VM-Write-Log-Exception $_
}
