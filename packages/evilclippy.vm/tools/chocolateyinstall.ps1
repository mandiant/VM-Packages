$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'EvilClippy'
$category = 'Payload Development'

$zipUrl = 'https://github.com/outflanknl/EvilClippy/archive/refs/tags/v1.3.zip'
$zipSha256 = '6ff1633de0ce8b99d5cf59a3e3cddf1960d4e7410d1441fd86940db42a7785a7'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
