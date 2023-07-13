$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'CredNinja'
$category = 'Credential Access'

$zipUrl = 'https://github.com/Raikia/CredNinja/archive/4a13f297851cd6fe88017288e6850ad276078071.zip'
$zipSha256 = '35b7dfae877c08bd9e50a5b9406eead0687b460db9428b9fe22130cc47b1ec10'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
