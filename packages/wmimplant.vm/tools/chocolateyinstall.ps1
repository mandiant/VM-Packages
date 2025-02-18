$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'WMImplant'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$ps1Url = 'https://raw.githubusercontent.com/RedSiege/WMImplant/0ed3c3cba9c5e96d0947c3e73288d450ac8d8702/WMImplant.ps1'
$ps1Sha256 = '4226f7d50145fadce8b564b5dadfa38d067e155173af1dba4d41afb4a2d5b2ab'
$ps1Cmd = ". .\WMImplant; Invoke-WMImplant"

VM-Install-Single-Ps1 $toolName $category $ps1Url -ps1Sha256 $ps1Sha256 -ps1Cmd $ps1Cmd
