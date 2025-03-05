$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.6.0/SharpHound-v2.6.0.zip'
$zipSha256 = '2c48703455ce3a217b7c1b768ac729c696cb6811bc3eb20fd60927b2ffc66b0e'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
