$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SCLauncher'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/jstrosch/sclauncher/releases/download/v0.0.6/sclauncher.exe'
$exeSha256 = 'cd00e0383b4dce2ffd78614c586bf9629df4bcc02c09cf439421fd9af798050f'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
