$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'unpyc3'
$category = 'Python'

VM-Pip-Install "https://github.com/greyblue9/unpyc37-3.10/archive/c1486ce3cf5b8fdfb5065e9c81a73a61481ed9ff.zip"

$pyPath = (Get-Command py).Source
VM-Install-Shortcut -toolName $toolName -category $category -executablePath $pyPath -consoleApp $true -arguments "-3.10 -m unpyc.unpyc3"
