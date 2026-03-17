$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'MFTECmd'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://download.ericzimmermanstools.com/net9/MFTECmd.zip'
$zipSha256 = 'd8124cfe0344bdf4e01bb96cf46900c194ecd7df364d335a1bb3e883a1b34e44'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
