$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release' -Resolve

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/x64dbg/x64dbgpy/releases/download/b275005/x64dbgpy_b275005.zip'
    checksum      = '62ffbbcf0218c3b833bcb36c2a10671c4501007759a84164b63f09e9f2ce9bfc'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  # Check for a few expected files to ensure installation succeeded
  Join-Path $toolDir 'x64dbgpy.h' -Resolve | Out-Null
  Join-Path $toolDir 'x64dbgpy_x64.lib' -Resolve | Out-Null
  Join-Path $toolDir 'x64dbgpy_x86.lib' -Resolve | Out-Null
} catch {
  VM-Write-Log-Exception $_
}