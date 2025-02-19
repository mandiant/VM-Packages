$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'setdllcharacteristics'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://www.didierstevens.com/files/software/setdllcharacteristics_v0_0_0_1.zip'
$zipSha256 = '5a9d3815f317c7c0ff7737f271ce0c60be2cb0f4168c5ea5ad8cef84ad718577'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

