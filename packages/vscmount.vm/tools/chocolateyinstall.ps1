$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'VSCMount'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/VSCMount.zip'
$zipSha256 = '8af3e9b85513f05e73d42fd325f0b31915457209167f0e141b6b4c8233854994'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
