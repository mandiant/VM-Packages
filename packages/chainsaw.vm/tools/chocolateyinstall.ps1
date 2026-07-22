$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'chainsaw'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/WithSecureLabs/chainsaw/releases/download/v2.16.2/chainsaw_all_platforms+rules.zip'
$zipSha256 = '210d174b96da9421b0897daf2e4dd5fc01be4fa45790974247a76071b127c899'

$executableName = $toolName + "_x86_64-pc-windows-msvc.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $true -executableName $executableName
