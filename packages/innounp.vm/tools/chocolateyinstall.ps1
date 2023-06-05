$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'innounp'
$category = 'Utilities'

$exeUrl = 'https://github.com/WhatTheBlock/innounp/releases/download/v0.50/innounp.exe'
$exeSha256 = '9b72ad9f93d167652a0e2bf3921abdfd3e6747c5e718461a2e58b9dfacd31f4c'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
