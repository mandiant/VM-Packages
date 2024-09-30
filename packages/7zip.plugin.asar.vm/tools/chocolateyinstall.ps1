$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = "Asar"
  $pluginsDir = Join-Path ${Env:ProgramFiles} "7-Zip\Formats"
  New-Item -ItemType Directory -Force -Path $pluginsDir | Out-Null

  $pluginUrl = "https://www.tc4shell.com/binary/Asar.zip"
  $pluginSha256 = "ea17751b2d7d607dfc11612e71d0c9d36561e643cdfb2bfb16922a9a0ec6d250"

  $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $tempDownloadDir
      url            = $pluginUrl
      checksum       = $pluginSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs | Out-Null
  VM-Assert-Path $tempDownloadDir

  Copy-Item "$tempDownloadDir\$toolName.64.dll" $pluginsDir
  VM-Assert-Path (Join-Path $pluginsDir "$toolName.64.dll")

  Remove-Item $tempDownloadDir -Recurse -Force -ea 0
} catch {
  VM-Write-Log-Exception $_
}
