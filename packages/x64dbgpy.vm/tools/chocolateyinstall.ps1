$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release' -Resolve

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/x64dbg/x64dbgpy/releases/download/8c0538a/x64dbgpy_8c0538a.zip'
    checksum      = 'e8184fb4e7bf36f33a3727b6ec76088464f7b745c9b44ef65f82be4bff8e6d19'
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