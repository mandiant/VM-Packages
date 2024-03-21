$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'bstrings'
$category = 'Utilities'

$zipUrl = 'https://f001.backblazeb2.com/file/EricZimmermanTools/net6/bstrings.zip'
$zipSha256 = '1521031bab2843757bb701b75741a24154965ba219a57cbfefddb792c6d5b301'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
