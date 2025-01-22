$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = 'Forensic'

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.11.0/chainsaw_all_platforms+rules.zip'
$zipSha256 = 'a67f1fbd57efa02c281cad892b9e0b6f90ccc99035961935048191d055a543b7'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
