$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SeatBelt'
$Category = 'Reconnaissance'

$zipUrl = 'https://github.com/GhostPack/Seatbelt/archive/96bd958cf45e3d877d842ce20906e1aa5fdc91c8.zip'
$zipSha256 = '05f6da0d0b77adfae105f2030862882fc8790cf47d98ec053762b9ac99250184'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
