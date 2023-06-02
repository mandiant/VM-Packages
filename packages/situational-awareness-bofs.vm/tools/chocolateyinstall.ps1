$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/trustedsec/CS-Situational-Awareness-BOF/archive/82235696478ec49fc10bc09a11483d75dddd0a45.zip'
$zipSha256 = '4f32d34529e6f7b6b287bd61a768c1e56345de8e563da7d4b15661552d8a5037'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
