$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the plugin
    $toolName    = "lighthouse"
    $toolVersion = "0.9.3"
    $toolDir     = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
    $toolUrl     = "https://github.com/gaasedelen/lighthouse/archive/refs/tags/v0.9.3.zip"
    $toolSha256  = "b9f1888827f68d69672d1202783b47f7603fb80f42f9b70edeb9349d40c4f33c"
    $packageArgs =
    @{
        packageName   = ${Env:ChocolateyPackageName}
        unzipLocation = $toolDir
        url           = $toolUrl
        checksum      = $toolSha256
        checksumType  = "sha256"
    }
    Install-ChocolateyZipPackage @packageArgs

    # Install the plugin
    $pluginsDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\plugins" -ItemType "directory" -Force
    $pluginFile = Join-Path $toolDir "$toolName-$toolVersion\plugins\lighthouse_plugin.py" -Resolve
    $pluginDir  = Join-Path $toolDir "$toolName-$toolVersion\plugins\lighthouse" -Resolve
    Copy-Item $pluginFile -Destination $pluginsDir -Force
    Copy-Item $pluginDir  -Destination $pluginsDir -Force -Recurse

    # Remove the temp installation folder
    Remove-Item $toolDir -Recurse

    # Install the code coverage binaries
    $toolName  = "CodeCoverage"
    $zipUrl    = "https://github.com/gaasedelen/lighthouse/releases/download/v$toolVersion/CodeCoverage-v$toolVersion-98830.zip"
    $zipSha256 = "5b3e9659e934f8d7f4751cc0e20aa76de28822bc4f28b4936aa9be9c9e108595"

    $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

    # Download and unzip
    $packageArgs = @{
        packageName    = $toolName
        unzipLocation  = $toolDir
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = "sha256"
    }
    Install-ChocolateyZipPackage @packageArgs
    VM-Assert-Path $toolDir
} catch {
  VM-Write-Log-Exception $_
}
