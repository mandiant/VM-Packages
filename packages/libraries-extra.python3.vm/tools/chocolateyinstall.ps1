$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $dependencies = "asciinet,bs4,flare_capa,langchain,langchain_google_genai,langchain_openai,networkx,python-statemachine,requests,tabulate,tenacity"
    VM-Pip-Install $dependencies
} catch {
    VM-Write-Log-Exception $_
}
