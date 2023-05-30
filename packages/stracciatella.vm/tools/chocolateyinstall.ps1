$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Stracciatella'
$category = 'Command & Control'

$zipUrl = 'https://github.com/mgeeky/Stracciatella/archive/acc83e21951049ab4998ecd18f5e4fa01e1527da.zip'
$zipSha256 = 'd9299fca780945becf9907b052112e7149fb2a2d51e28f0e73e8326455f47a82'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
