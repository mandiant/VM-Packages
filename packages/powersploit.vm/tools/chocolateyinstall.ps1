$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerSploit'
$category = 'Active Directory'

$zipUrl = 'https://github.com/ZeroDayLab/PowerSploit/archive/72a88240ed0c6527f3880a1fb15ea7a19589c2d8.zip'
$zipSha256 = '4a86b4b92e97fe6f1d76d8d93d9e481c007809db803cc82f4f0ec86ff7186bcf'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
