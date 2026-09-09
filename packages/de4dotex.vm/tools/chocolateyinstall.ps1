$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'de4dotex'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/GDATAAdvancedAnalytics/de4dotEx/releases/download/3.9.0/de4dotEx-3.9.0-net8.0-win-x64.zip'
$zipSha256 = '1f83584d702c5dd8f9917aa24563f66bab8dc451f50512bdbe30ab48e47c9253'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'de4dot.exe'
