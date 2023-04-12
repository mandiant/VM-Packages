$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SQLRecon'
$category = 'Exploitation'

$exeUrl = 'https://github.com/skahwah/SQLRecon/releases/download/v2.2.2/SQLRecon.exe'
$exeSha256 = '36efd1025ff8379d5b85904160e7dba7c59f4b180f1b03de2a72531c1e9b82cf'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
