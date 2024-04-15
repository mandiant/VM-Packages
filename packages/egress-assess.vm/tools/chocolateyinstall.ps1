$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Egress-Assess'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/RedSiege/Egress-Assess/archive/8843e3c209df6c585af0b81b4751126004ff0f99.zip'
$zipSha256 = '97d5597c50eb8b394f98119ea25987ec4f7e82d93894fdfb51d1a84b427ed6f6'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
