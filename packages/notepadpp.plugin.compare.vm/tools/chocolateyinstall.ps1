$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "ComparePlugin"
  $pluginsDir= Join-Path ${Env:ProgramFiles} "Notepad++\plugins" -Resolve
  $toolDir = New-Item (Join-Path $pluginsDir $toolName) -itemtype directory
  VM-Assert-Path $toolDir

  $zipUrl= "https://github.com/pnedev/compare-plugin/releases/download/v2.0.1/ComparePlugin_v2.0.1_x86.zip"
  $zipSha256 ="07972c1c7e3012a46ac6ef133a6500ca851bddc9c83471df2f118519a0241ed5"
  $zipUrl_64 = "https://github.com/pnedev/compare-plugin/releases/download/v2.0.1/ComparePlugin_v2.0.1_X64.zip"
  $zipSha256_64 ="77dedf98ea2280528d726c0053db2001e90da7588e14ee01a98933f121bb15cb"

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
