$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.5.13/SharpHound-v2.5.13.zip'
$zipSha256 = '9df25d2a8a999c9871639c8e53bedf3bcdfc5c1c6250f77e8d416c38c167121f'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
