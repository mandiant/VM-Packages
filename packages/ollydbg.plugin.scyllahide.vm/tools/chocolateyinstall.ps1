$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolSrcDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    $toolSrcDir = Join-Path $toolSrcDir 'ScyllaHide'

    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $toolSrcDir
        url           = 'https://github.com/x64dbg/ScyllaHide/releases/download/snapshot-2021-08-23_13-27-50/ScyllaHide.7z'
        checksum      = 'c51929341ff726d219e670928433a176e114ca9a4c36f416629aef50c98b8817'
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