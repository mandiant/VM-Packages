$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'hayabusa'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.1.1/hayabusa-3.1.1-win-x64.zip"
$zipSha256 = '340f3846d86856d92f1e0d93fecccd81e020c10110f290603befc289607ce804'

$executableName = $toolName.ToLower() + "-3.1.1-win-x64.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -executableName $executableName
