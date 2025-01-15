$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $dependencies = "asciinet,bs4,flare_capa,langchain,langchain_google_genai,langchain_openai,networkx,python-statemachine,requests,tabulate,tenacity"
    VM-Pip-Install $dependencies

    $pluginName = 'xrefer.py'
    $pluginUrl = 'https://github.com/mandiant/xrefer/archive/refs/tags/v1.0.2.zip'
    $pluginSha256 = '91889099eea283dac33e76cca4a1c687a387e43fd0f8f3af1867be35111e262d'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
    VM-Write-Log-Exception $_
}
