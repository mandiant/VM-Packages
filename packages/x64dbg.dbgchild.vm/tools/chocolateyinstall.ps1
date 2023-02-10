$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} 'x64dbg\release' -Resolve
    $packageArgs = @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $tempDownloadDir
        url           = 'https://github.com/therealdreg/DbgChild/releases/download/beta10/DbgChild.Beta.10.zip'
        checksum      = 'f17f588795d8f5f94d71335a8acfa58946bb03a94a5637be7f3e804c652ea2b4'
        checksumType  = 'sha256'
    }

    VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}
    Install-ChocolateyZipPackage @packageArgs
    $unzippedDir = (Get-ChildItem -Directory $tempDownloadDir | Where-Object {$_.PSIsContainer} | Select-Object -f 1).FullName
    VM-Assert-Path $unzippedDir

    $archs = @("x32", "x64")
    foreach ($arch in $archs) {
        $archDstDir = Join-Path $toolDir "${arch}" -Resolve
        $pluginDstDir = Join-Path $archDstDir 'plugins'
        if (-Not (Test-Path $pluginDstDir -PathType Container)) {
            New-Item -ItemType directory $pluginDstDir -Force -ea 0 | Out-Null
        }
        VM-Assert-Path $pluginDstDir

        # Move 32/64-bit plugin DLL itself into the arch directory
        $pluginSrcPath = Join-Path $unzippedDir "release\${arch}\plugins" -Resolve
        Get-ChildItem -Path $pluginSrcPath -File | Move-Item -Destination $pluginDstDir -Force

        # Note that we don't simply move all children including directories, because we don't want to overwrite plugins

        # Move all the other arch-specific files
        $archSrcPath = Join-Path $unzippedDir "release\${arch}" -Resolve
        Get-ChildItem -Path $archSrcPath -File | Move-Item -Destination $archDstDir -Force
        if (-Not(Test-Path "${archDstDir}\CPIDS" -PathType Container)) {
            New-Item -ItemType directory "${archDstDir}\CPIDS" -Force -ea 0 | Out-Null
        }
    }

    # Move the NewProcessWatcher and text files into the main x64dbg directory
    $releaseSrcDir = Join-Path $unzippedDir 'release'

    Get-ChildItem -Path $releaseSrcDir -File | Move-Item -Destination $toolDir -Force
    if (-Not(Test-Path "${toolDir}\dbgchildlogs" -PathType Container)) {
        Move-Item -Path "${releaseSrcDir}\dbgchildlogs" -Destination $toolDir
    }

    # Make sure at least one of the files in each dir ended up in the right place
    VM-Assert-Path "${toolDir}\NewProcessWatcher.exe"
    VM-Assert-Path "${toolDir}\x32\CreateProcessPatch.exe"
    VM-Assert-Path "${toolDir}\x64\CreateProcessPatch.exe"
    VM-Assert-Path "${toolDir}\x32\plugins\dbgchild.dp32"
    VM-Assert-Path "${toolDir}\x64\plugins\dbgchild.dp64"

    # $unzippedDir is in $tempDownloadDir, so this should clean up both of them
    Remove-Item $tempDownloadDir -Recurse -Force -ea 0
} catch {
    VM-Write-Log-Exception $_
}
