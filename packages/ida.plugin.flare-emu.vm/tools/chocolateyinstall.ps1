$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $pluginUrl = 'https://github.com/mandiant/flare-emu/archive/refs/tags/2025-08-14.zip'
    $pluginSha256 = '172c721b4fb8c3d90a3d6a5352eaf466bfa904c14b36fc39468b9846fc3c9bef'

    $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
    # Download and unzip
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $tempDownloadDir
        url            = $pluginUrl
        checksum       = $pluginSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs | Out-Null
    VM-Assert-Path $tempDownloadDir

    # Copy scripts to IDA python directory
    $pythonDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\python" -ItemType "directory" -Force
    $scriptDir = Get-Item "$tempDownloadDir\flare-emu-2025-08-14"
    $scriptNames = @('flare_emu.py',
                     'flare_emu_hooks.py',
                     'flare_emu_ida.py',
                     'rename_dynamic_imports.py')
    ForEach ($scriptName in $scriptNames) {
        $scriptPath = Join-Path $scriptDir $scriptName -Resolve
        Copy-Item $scriptPath $pythonDir -Force
    }
} catch {
    VM-Write-Log-Exception $_
}
