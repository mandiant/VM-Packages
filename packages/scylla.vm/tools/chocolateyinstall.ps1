$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scylla'
$category = 'PE'

$zipUrl = 'https://github.com/NtQuery/Scylla/releases/download/v0.9.8/Scylla_v0.9.8.rar'
$zipSha256 = '48a4338d999ec5f33b5964c51893a04fc9e2d104b0c7786f50751f7db5dcbe52'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
