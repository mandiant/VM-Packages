$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install dependency: capa Python library
    $version = "9.2.1"
    VM-Pip-Install "flare-capa==$version"

    # Install plugin
    $pluginName = "capa_explorer.py"
    $pluginUrl = "https://raw.githubusercontent.com/mandiant/capa/v$version/capa/ida/plugin/capa_explorer.py"
    $pluginSha256 = "0470f7dd693f3d974c71397a0b484ddc6a21a0ee4c971de2c2097509a093345d"
    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256


    # Download capa rules
    $pluginsDir = VM-Get-IDA-Plugins-Dir
    $rulesUrl = "https://github.com/mandiant/capa-rules/archive/refs/tags/v$version.zip"
    $rulesSha256 = "9d5c1aa70ef7e3ccf4a4603a15181af3b0ca12c72de01e0eccce894c9b51d9a3"
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $pluginsDir
        url            = $rulesUrl
        checksum       = $rulesSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $rulesDir = Join-Path $pluginsDir "capa-rules-$version" -Resolve

    # Set capa rules in the capa plugin
    $registryPath = 'HKCU:\SOFTWARE\IDAPython\IDA-Settings\capa'
    New-Item $registryPath -Force | Out-Null
    # ida_settings expects '/' in the rule path
    $value = $rulesDir.replace("\", "/")
    Set-ItemProperty $registryPath -Name "rule_path" -Value "`"$value`"" -Force | Out-Null
} catch {
  VM-Write-Log-Exception $_
}

