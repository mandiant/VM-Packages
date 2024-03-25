$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the plugin
    $pluginUrl    = "https://raw.githubusercontent.com/airbus-cert/comida/177ea45f98b153552dc13545dda64a6a26fab0a0/comida.py"
    $pluginPath   = Join-Path ${Env:TEMP} "comida.py"
    $pluginSha256 = "95E33B6B8AFD44A4C924AE2BD8779C645751926F9312A99D3332066388D55BE6"
    $packageArgs  = @{
        packageName   = ${Env:ChocolateyPackageName}
        url           = $pluginUrl
        checksum      = $pluginSha256
        checksumType  = "sha256"
        fileFullPath  = $pluginPath
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $pluginPath

    # Install the plugin
    $pluginsDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\plugins" -ItemType "directory" -Force
    Move-Item $pluginPath -Destination $pluginsDir -Force
} catch {
    VM-Write-Log-Exception $_
}
