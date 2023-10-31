$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Internal-Monologue'
$category = 'Credential Access'

$zipUrl = 'https://github.com/eladshamir/Internal-Monologue/archive/4694611f78f211ca4a0381cd3daca1310ced4293.zip'
$zipSha256 = '262369744f1cbb468bb79e6c0a6b21aee3b18e20d2abea99b5dd0d12ea43325f'

VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
