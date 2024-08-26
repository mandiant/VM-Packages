$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RBCmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/RBCmd.zip'
$zipSha256 = '326b4d77bd2915551b85391bdebf1dc4a32bc5a872a4da0d55af8df657086135'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
