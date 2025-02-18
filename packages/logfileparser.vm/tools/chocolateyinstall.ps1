$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LogFileParser64'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/jschicht/LogFileParser/releases/download/v2.0.0.51/LogFileParser_v2.0.0.51.zip'
$zipSha256 = '08d1e40e943857c1f46e22c0a7d87545514afbbc21e9ccbc7b80f8ae78495924'

VM-Install-From-Zip -toolName $toolName -category $category -zipUrl $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
