$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PowerCat'
$category = 'Utilities'

$ps1Url = 'https://raw.githubusercontent.com/besimorhino/powercat/4bea00079084c7dbc52105ce5b5988b036821c92/powercat.ps1'
$ps1Sha256 = 'c55672b5d2963969abe045fe75db52069d0300691d4f1f5923afeadf5353b9d2'

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256
