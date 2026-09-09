$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'uv'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = "https://github.com/astral-sh/uv/releases/download/0.12.12/uv-x86_64-pc-windows-msvc.zip"
$zipSha256 = "3d54912924c36e862c14f427d04f2ed70a99e8001d1c30caa101f6d5711626d5"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -arguments "--help"
