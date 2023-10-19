$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the plugin
    $toolDir    = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
    $toolUrl    = "https://github.com/x64dbg/ScyllaHide/releases/download/v1.4/ScyllaHide_2023-03-24_13-03.zip"
    $toolSha256 = "edeb0dd203fd1ef38e1404e8a1bd001e05c50b6096e49533f546d13ffdcb7404"
    $packageArgs   =
    @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $toolDir
        url            = $toolUrl
        checksum       = $toolSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs

    # Install the plugin
    $pluginsDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\plugins" -ItemType "directory" -Force
    $pluginPath = Join-Path $toolDir "IDA\HookLibraryx64.dll" -Resolve
    $configPath = Join-Path $toolDir "IDA\scylla_hide.ini" -Resolve
    Copy-Item $pluginPath -Destination $pluginsDir
    Copy-Item $configPath -Destination $pluginsDir

    # Remove the temp installation folder
    Remove-Item $toolDir -Recurse
} catch {
  VM-Write-Log-Exception $_
}