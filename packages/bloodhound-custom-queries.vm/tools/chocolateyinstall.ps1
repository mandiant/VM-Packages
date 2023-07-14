$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BloodHound-Custom-Queries'
$category = 'Reconnaissance'

$zipUrl = 'https://github.com/hausec/Bloodhound-Custom-Queries/archive/7ef9099665aa82238bfd57d7a11c09cd4dd9381b.zip'
$zipSha256 = '78a71b9797506200b4c86bdad6799ba8c3519171353ce329dff5ff4fc703ddb0'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
