$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolSrcDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $toolSrcDir = Join-Path $toolSrcDir 'ScyllaHide'

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolSrcDir
    url           = 'https://github.com/x64dbg/ScyllaHide/releases/download/snapshot-2021-08-23_13-27-50/ScyllaHide.7z'
    checksum      = 'c51929341ff726d219e670928433a176e114ca9a4c36f416629aef50c98b8817'
    checksumType  = 'sha256'
  }

  # Create $toolSrcDir if not exist
  if (-Not (Test-Path $toolSrcDir)) {
      New-Item -ItemType directory $toolSrcDir -Force -ea 0
  }
  VM-Assert-Path $toolSrcDir

  Install-ChocolateyZipPackage @packageArgs

  $pluginSrcPath = Join-Path $toolSrcDir 'Olly2' -Resolve
  $toolDstDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg2' -Resolve

  if ( -Not (Test-Path $toolDstDir -PathType Container)) {
    New-Item -ItemType directory $toolDstDir -Force -ea 0
  }
  VM-Assert-Path $toolDstDir

  # Move plugin into the tool directory
  $pluginDstPath = Join-Path $toolDstDir $pluginFile
  Get-ChildItem -Path $pluginSrcPath -Recurse -File | Move-Item -Destination $pluginDstPath -Force -ea 0
  VM-Assert-Path $pluginDstPath
} catch {
  VM-Write-Log-Exception $_
}