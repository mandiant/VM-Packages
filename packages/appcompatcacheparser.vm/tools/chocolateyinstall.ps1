$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AppCompatCacheParser'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/AppCompatCacheParser.zip'
$zipSha256 = '0ef9cc96a0784bc54f79e584f5845f7e3ada703cbfb6e209e9612bf1f7aad6c9'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
