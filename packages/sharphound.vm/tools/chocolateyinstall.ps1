$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SharpHound'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/BloodHoundAD/SharpHound/releases/download/v2.6.2/SharpHound-v2.6.2.zip'
$zipSha256 = '70755670c212cc6bc75bfb419f89de4da579858cdb590c596eaf0d6852625310'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
