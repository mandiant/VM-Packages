$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerZure'
$category = 'Cloud'

$zipUrl = 'https://github.com/hausec/PowerZure/archive/093d4a3267ab514656759d7b2a6a91ac521b449b.zip'
$zipSha256 = '76e82df57013980cd6f3dd5b125e405e4ab3308368f2372121581a6a1e4a5a22'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
