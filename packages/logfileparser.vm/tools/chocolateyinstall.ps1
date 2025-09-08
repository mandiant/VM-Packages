$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LogFileParser64'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/jschicht/LogFileParser/releases/download/v2.0.0.53/LogFileParser_v2.0.0.53.zip'
$zipSha256 = '68fb4f9f54135e1951febf825de37e47fe13b2ac2733fcc63e8fe26dd729e58a'

VM-Install-From-Zip -toolName $toolName -category $category -zipUrl $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
