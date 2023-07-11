$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerMad'
$category = 'Android'

$zipUrl = 'https://github.com/Kevin-Robertson/Powermad/archive/3ad36e655d0dbe89941515cdb67a3fd518133dcb.zip'
$zipSha256 = 'e01cfdb69f938ecd8c707e81dce2832935bb26e368405f2180b6858bce5b4d73'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
