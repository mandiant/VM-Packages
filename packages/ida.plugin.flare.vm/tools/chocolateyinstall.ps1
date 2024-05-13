$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $pluginUrl = 'https://github.com/mandiant/flare-ida/archive/011cb3310d82a1c00104a4830289ea2fed5165f5.zip'
    $pluginSha256 = 'd74c81d9fb1db2de801a05aeeb289ea98d93604aa11e44b27568382e78225bb2'

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

    # Copy plugins to IDA plugins directory
    $pluginsDir = VM-Get-IDA-Plugins-Dir
    $pluginDir = Get-Item "$tempDownloadDir\*\plugins"
    $pluginNames = @('apply_callee_type_plugin.py',
                     'shellcode_hashes_search_plugin.py')
    ForEach ($pluginName in $pluginNames) {
        $pluginPath = Join-Path $pluginDir $pluginName -Resolve
        Copy-Item $pluginPath $pluginsDir -Force
    }

    # Copy flare Python module to the IDA plugins directory
    $flareDir = Get-Item "$tempDownloadDir\*\python\flare"
    Copy-Item $flareDir $pluginsDir -Recurse -Force

    # Copy sc_hashes.db to a directory where shellcode_hashes_search_plugin.py can find it:
    # https://github.com/mandiant/flare-ida/blob/011cb3310d82a1c00104a4830289ea2fed5165f5/python/flare/shellcode_hash_search.py#L428
    $dbFile = Get-Item "$tempDownloadDir\*\shellcode_hashes\sc_hashes.db"
    $dbDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\shellcode_hashes" -ItemType "directory" -Force
    Copy-Item $dbFile $dbDir -Recurse -Force
} catch {
    VM-Write-Log-Exception $_
}

