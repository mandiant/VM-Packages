$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SecLists'
$category = 'Wordlists'

$zipUrl = 'https://github.com/danielmiessler/SecLists/archive/refs/tags/2023.2.zip'
$zipSha256 = 'ecb58f0a4a311b152c6debbd0d699a14e42ea9b6d1964ef8fc06151b26c435a8'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
