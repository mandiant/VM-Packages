$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uv'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/astral-sh/uv/releases/download/0.10.9/uv-x86_64-pc-windows-msvc.zip"
$zipSha256 = "f58dc40896000229db7c52b8bdd931394040ef2ad59abd1eda841f6d70b13d7a"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
