$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pylingual'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

VM-Pip-Install 'https://github.com/syssec-utd/pylingual/archive/9f0ba2aa0195ce853b65e1064e8aaae09b67966f.zip'

$pyPath = (Get-Command py).Source
VM-Install-Shortcut $toolName $category -executablePath $toolName -consoleApp $true -arguments "--help" -iconLocation $pyPath
