$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'bstrings'
$category = 'Utilities'

$zipUrl = 'https://download.mikestammer.com/net6/bstrings.zip'
$zipSha256 = '8de97628d13a76a27873cb9a796b14c58119079b0ddbe599bb0c4f4ee06af691'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
