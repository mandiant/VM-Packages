$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Install plugin
    $pluginName = "capa_explorer.py"
    $pluginUrl = "https://raw.githubusercontent.com/mandiant/capa/v7.0.1/capa/ida/plugin/capa_explorer.py"
    $pluginSha256 = "a9a60d9066c170c4e18366eb442f215009433bcfe277d3c6d0c4c9860824a7d3"
    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256


    # Download capa rules
    $pluginsDir = VM-Get-IDA-Plugins-Dir
    $rulesUrl = "https://github.com/mandiant/capa-rules/archive/refs/tags/v7.0.1.zip"
    $rulesSha256 = "f4ed60bcf342007935215ea76175dddfbcbfb3f97d95387543858e0c1ecf8bcd"
    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = $pluginsDir
        url            = $rulesUrl
        checksum       = $rulesSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $rulesDir = Join-Path $pluginsDir "capa-rules-7.0.1" -Resolve

    # Set capa rules in the capa plugin
    $registryPath = 'HKCU:\SOFTWARE\IDAPython\IDA-Settings\capa'
    New-Item $registryPath -Force | Out-Null
    # ida_settings expects '/' in the rule path
    $value = $rulesDir.replace("\", "/")
    Set-ItemProperty $registryPath -Name "rule_path" -Value "`"$value`"" -Force | Out-Null
} catch {
  VM-Write-Log-Exception $_
}

