$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $dependencies = "asciinet,bs4,flare_capa,langchain,langchain_google_genai,langchain_openai,networkx,python-statemachine,requests,tabulate,tenacity"
    VM-Pip-Install $dependencies

    $pluginName = 'xrefer.py'
    $pluginUrl = 'https://github.com/mandiant/xrefer/archive/refs/tags/v1.0.0.zip'
    $pluginSha256 = '8c1b5cee59674e104e0bac20f908e9b3cf17af25b18b3ed80a845b62b257e7f1'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
    VM-Write-Log-Exception $_
}
