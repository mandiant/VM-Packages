$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$category = 'Command & Control'

$zipUrl = 'https://github.com/trustedsec/CS-Situational-Awareness-BOF/archive/refs/heads/master.zip'
$zipSha256 = 'e3673d7e41ad6d36ca7d6d44821f68238aae9968e062acb6d96fc7663c87bbdb'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
