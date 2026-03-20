$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'unpyc3'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Pip-Install "https://github.com/greyblue9/unpyc37-3.10/archive/c1486ce3cf5b8fdfb5065e9c81a73a61481ed9ff.zip"

$pyPath = (Get-Command py).Source
VM-Install-Shortcut $toolName $category $pyPath -consoleApp $true -arguments "-3.13 -m unpyc.unpyc3"
