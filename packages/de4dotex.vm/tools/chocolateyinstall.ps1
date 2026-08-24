$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'de4dotex'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/GDATAAdvancedAnalytics/de4dotEx/releases/download/3.8.0/de4dotEx-3.8.0-net8.0-win-x64.zip'
$zipSha256 = '544a340f870c3774471934e64b4d93dfd0cc4ecdc4c19e904a991bc73294f193'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -executableName 'de4dot.exe'
