$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Invoke-DOSfuscation'
$category = 'Payload Development'

$zipUrl = 'https://github.com/danielbohannon/Invoke-DOSfuscation/archive/6260f5b5848b967446371ee7800aaa0409ea23cc.zip'
$zipSha256 = '60b78094731fc8f54333193e840cb847ac4018c6ca1ccc36c107cda533016791'

$powershellCommand = 'Import-Module .\Invoke-DOSfuscation.psd1; Invoke-DOSfuscation'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
