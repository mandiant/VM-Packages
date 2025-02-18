$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotDumper'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/advanced-threat-research/DotDumper/releases/download/1.1/DotDumper.zip'
$zipSha256 = '504bce7018041dfc1a7c3ecc28443a3b7648a25e9d1430b5875c11a39b686a98'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true
