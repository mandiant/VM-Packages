$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-Obfuscation'
$category = 'Payload Development'

$zipUrl = 'https://github.com/danielbohannon/Invoke-Obfuscation/archive/f20e7f843edd0a3a7716736e9eddfa423395dd26.zip'
$zipSha256 = '24149efe341b4bfc216dea22ece4918abcbe0655d3d1f3c07d1965fac5b4478e'

$powershellCommand = 'Import-Module ./Invoke-Obfuscation.psd1; Invoke-Obfuscation'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
