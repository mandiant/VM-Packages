$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install dependency: capa Python library
    $version = "8.0.1"
    VM-Pip-Install "flare-capa==$version"

    # Install plugin
    $pluginName = "capa_explorer.py"
    $pluginUrl = "https://raw.githubusercontent.com/mandiant/capa/v$version/capa/ida/plugin/capa_explorer.py"
    $pluginSha256 = "bf6c9a0e5fd2c75a93bb3c19e0221c36cda441c878af3c23ea3aafef4fecf3e9"
    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256


    # Download capa rules
    $pluginsDir = VM-Get-IDA-Plugins-Dir
    $rulesUrl = "https://github.com/mandiant/capa-rules/archive/refs/tags/v$version.zip"
    $rulesSha256 = "7c5f932b1da4e18eed50add117e7fc55c14dc51487495cb31e33e0b44c522fbc"
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

