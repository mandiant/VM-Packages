$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SafetyKatz'
$category = 'Credential Access'

$zipUrl = 'https://github.com/GhostPack/SafetyKatz/archive/715b311f76eb3a4c8d00a1bd29c6cd1899e450b7.zip'
$zipSha256 = '97ed587a816ef87a310d43dba7b0370ab4cbc1756dbed102e38662abce84a81d'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
