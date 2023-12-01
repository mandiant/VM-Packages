$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'innoextract'
$category = 'InnoSetup'

$zipUrl = 'https://constexpr.org/innoextract/files/innoextract-1.9/innoextract-1.9-windows.zip'
$zipSha256 = '6989342c9b026a00a72a38f23b62a8e6a22cc5de69805cf47d68ac2fec993065'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
