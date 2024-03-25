$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerUpSQL'
$category = 'Exploitation'

$zipUrl = 'https://github.com/NetSPI/PowerUpSQL/archive/2837c7bdda47a07703b7841080024f30a73a7743.zip'
$zipSha256 = 'fffed1c3f480b40616070e7ebb5bf7e8093e0bb483ce1ef2400f586018439c85'

$powershellCommand = 'Import-Module .\PowerUpSQL.psd1; Get-Command -Module PowerUpSQL'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -innerFolder $true -powershellCommand $powershellCommand
