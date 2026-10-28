$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v4.3.0/hayabusa-4.3.0-win-x64.zip"
$zipSha256 = '27464d03e24e779b27d67e8d3eeeae6d8aa702a16ec05112e6beb1814bb01877'

$executableName = $toolName.ToLower() + "-4.3.0-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
