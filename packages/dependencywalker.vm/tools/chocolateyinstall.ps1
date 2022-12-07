$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Dependency Walker'
$category = 'PE'

$zipUrl = 'https://dependencywalker.com/depends22_x64.zip'
$zipSha256 = '35db68a613874a2e8c1422eb0ea7861f825fc71717d46dabf1f249ce9634b4f1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
