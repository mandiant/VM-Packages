$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install plugin
    $pluginUrl = "https://raw.githubusercontent.com/mandiant/capa/v6.1.0/capa/ida/plugin/capa_explorer.py"
    $pluginSha256 = "a9a60d9066c170c4e18366eb442f215009433bcfe277d3c6d0c4c9860824a7d3"
    $pluginsDir = New-Item "$Env:APPDATA\Hex-Rays\IDA Pro\plugins" -ItemType "directory" -Force
    $pluginPath = Join-Path $pluginsDir "capa_explorer.py"
    $packageArgs = @{
        packageName = ${Env:ChocolateyPackageName}
        url = $pluginUrl
        checksum = $pluginSha256
        checksumType = "sha256"
        fileFullPath = $pluginPath
        forceDownload = $true
    }
    Get-ChocolateyWebFile @packageArgs
    VM-Assert-Path $pluginPath

    # Download capa rules
    $rulesUrl = "https://github.com/mandiant/capa-rules/archive/refs/tags/v6.1.0.zip"
    $rulesSha256 = "d87240475b2989e919f65381556f28b455a2f7d6cd35d95acdbbbe9f04f86c84"
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $pluginsDir
        url            = $rulesUrl
        checksum       = $rulesSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $rulesDir = Join-Path $pluginsDir "capa-rules-6.1.0" -Resolve

    # Set capa rules in the capa plugin
    $registryPath = 'HKCU:\SOFTWARE\IDAPython\IDA-Settings\capa'
    New-Item $registryPath -Force | Out-Null
    # ida_settings expects '/' in the rule path
    $value = $rulesDir.replace("\", "/")
    Set-ItemProperty $registryPath -Name "rule_path" -Value "`"$value`"" -Force | Out-Null
} catch {
  VM-Write-Log-Exception $_
}

