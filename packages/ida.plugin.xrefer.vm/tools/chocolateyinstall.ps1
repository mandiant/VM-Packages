$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $dependencies = "asciinet,bs4,flare_capa,langchain,langchain_google_genai,langchain_openai,networkx,python-statemachine,requests,tabulate,tenacity"
    VM-Pip-Install $dependencies

    $pluginName = 'xrefer.py'
    $pluginUrl = 'https://github.com/mandiant/xrefer/archive/refs/tags/v1.0.3.zip'
    $pluginSha256 = '631538a17dd5c4b99f530eb53ebbf67c8c3a915d4953178b14f234a0f9fb9d6f'

    VM-Install-IDA-Plugin -pluginName $pluginName -pluginUrl $pluginUrl -pluginSha256 $pluginSha256
} catch {
    VM-Write-Log-Exception $_
}
