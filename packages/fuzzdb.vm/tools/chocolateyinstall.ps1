$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FuzzDB'
$category = 'Wordlists'

$zipUrl = 'https://github.com/fuzzdb-project/fuzzdb/archive/5656ab25dc6bb43bae32236fab775658a90d7380.zip'
$zipSha256 = 'b732136975be06f71e8c8cfa6923a6dfba028b7f8c4cfa21c6280ef5b74aa1fa'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
