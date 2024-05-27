$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolSrcDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $toolSrcDir = Join-Path $toolSrcDir 'ScyllaHide'

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $toolSrcDir
        url           = 'https://github.com/x64dbg/ScyllaHide/releases/download/v1.4/ScyllaHide_2023-03-24_13-03.zip'
        checksum      = 'edeb0dd203fd1ef38e1404e8a1bd001e05c50b6096e49533f546d13ffdcb7404'
        checksumType  = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolSrcDir

    # Move plugin into the tool directory
    $toolDstDir = Join-Path ${Env:RAW_TOOLS_DIR} 'OllyDbg' -Resolve
    $pluginSrcPath = Join-Path $toolSrcDir "Olly1" -Resolve
    Get-ChildItem -Path $pluginSrcPath -Recurse -File | Move-Item -Destination $toolDstDir -Force -ea 0

    # Remove the downloaded files to prevent unnecessary shims
    Remove-Item -Path $toolSrcDir -Recurse -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}