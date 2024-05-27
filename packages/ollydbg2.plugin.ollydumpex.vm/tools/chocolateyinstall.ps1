$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $toolSrcDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolSrcDir
    url           = 'https://low-priority.appspot.com/ollydumpex/OllyDumpEx_v1.84.zip'
    checksum      = 'd83d59dce42f8a8bef2881bc5bcb8f4ded24d511a101696ad756b590420172d3'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs

  # Should unzip to the directory below
  $toolSrcDir = Join-Path $toolSrcDir 'OllyDumpEx_v1.84' -Resolve
  $pluginSrcPath = Join-Path $toolSrcDir 'OllyDumpEx_Od20.dll' -Resolve
  $toolDstDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg2' -Resolve

  # Move correct plugin into the tool directory
  $pluginDstPath = Join-Path $toolDstDir $pluginFile
  Move-Item -Path $pluginSrcPath -Destination $pluginDstPath -Force -ea 0
  VM-Assert-Path $pluginDstPath
} catch {
  VM-Write-Log-Exception $_
}