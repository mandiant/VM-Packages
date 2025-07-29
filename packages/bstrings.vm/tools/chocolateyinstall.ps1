$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'bstrings'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.mikestammer.com/net6/bstrings.zip'
$zipSha256 = 'BF1E806C9D94EE53905DA0FB247A15E4A27D29B26CE8A3EDBCA17081A902CE77'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
