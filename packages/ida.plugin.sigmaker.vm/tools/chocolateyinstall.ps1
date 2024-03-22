$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Download the plugin
	$pluginUrl    = "https://github.com/A200K/IDA-Pro-SigMaker/releases/download/v1.0.0/SigMaker64.dll"
	$pluginPath   = Join-Path ${Env:TEMP} "SigMaker.dll"
	$pluginSha256 = "D8D14721515B1473408D21C40A1F223E18D402647B78F97B685E1A534C184402"
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
