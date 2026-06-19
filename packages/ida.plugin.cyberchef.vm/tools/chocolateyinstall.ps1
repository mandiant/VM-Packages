$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install Python dependency: STPyV8 (which provides the JS engine)
    Write-Host "[+] Installing python dependency stpyv8..."
    VM-Pip-Install 'stpyv8'

    # Download and unzip the plugin repository zip
    $pluginUrl = 'https://github.com/HexRaysSA/ida-cyberchef/archive/48b5fa3124829ab3b9404b92f37f8f81ab617848.zip'
    $pluginSha256 = '2af958e0ca743659689be7ffb3184b6a1e17579750998450311817676ec0c93a'

    $tempDownloadDir = Join-Path ${Env:chocolateyPackageFolder} "temp_$([guid]::NewGuid())"
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $tempDownloadDir
        url            = $pluginUrl
        checksum       = $pluginSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs | Out-Null
    VM-Assert-Path $tempDownloadDir

    $pluginsDir = VM-Get-IDA-Plugins-Dir

    # Copy entrypoint file and rename to avoid conflicts with other plugins
    $entrypoint = Get-Item "$tempDownloadDir\*\entrypoint.py"
    Copy-Item $entrypoint (Join-Path $pluginsDir "ida_cyberchef.py") -Force

    # Copy python module folder
    $moduleDir = Get-Item "$tempDownloadDir\*\ida_cyberchef"
    Copy-Item $moduleDir $pluginsDir -Recurse -Force

} catch {
    VM-Write-Log-Exception $_
}
