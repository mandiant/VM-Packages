$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "ComparePlugin"
  $pluginsDir= Join-Path ${Env:ProgramFiles} "Notepad++\plugins" -Resolve
  $toolDir = New-Item (Join-Path $pluginsDir $toolName) -itemtype directory
  VM-Assert-Path $toolDir

  $zipUrl= "https://github.com/pnedev/compare-plugin/releases/download/v2.0.2/ComparePlugin_v2.0.2_x86.zip"
  $zipSha256 ="ea2f4cd6627c1b902f700a43b03b38f725e67136c8ce00ac3620ecc03417332a"
  $zipUrl_64 = "https://github.com/pnedev/compare-plugin/releases/download/v2.0.2/ComparePlugin_v2.0.2_X64.zip"
  $zipSha256_64 ="4151fbc9778047991cf4b900363d846bda5b0d1783e5fed9eb77e4c8253ba315"

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
