$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "JSMinNPP"
  $pluginsDir = Join-Path ${Env:ProgramFiles} "Notepad++\plugins" -Resolve
  $toolDir = New-Item (Join-Path $pluginsDir $toolName) -itemtype directory
  VM-Assert-Path $toolDir

  $zipUrl= "https://github.com/sunjw/jstoolnpp/raw/6bde4de9171975b445b5b8efa9153b10660bf5a7/trunk/ReleasedFiles/JSToolNPP.1.2312.0.uni.32.zip"
  $zipSha256 = "dc46e2bf466bd6431351e73bc332e47134b5e04d3c79cfc4738b79ecfed050ed"
  $zipUrl_64 = "https://github.com/sunjw/jstoolnpp/raw/6bde4de9171975b445b5b8efa9153b10660bf5a7/trunk/ReleasedFiles/JSToolNPP.1.2312.0.uni.64.zip"
  $zipSha256_64 ="bc819fad1a12a6a29392ad67dfb88d730bb8ac4ecee98f47bb73a0fab387c63e"

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
