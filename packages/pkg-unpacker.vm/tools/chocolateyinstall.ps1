$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'pkg-unpacker'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$zipUrl = 'https://github.com/LockBlock-dev/pkg-unpacker/archive/b1fd5200e1bf656dedef6817c177c8bb2dc38028.zip'
$zipSha256 = '6eed1d492d37ca3934a3bc838c2256719a3e78ccf72ce1b1ca07684519ace16c'
$command = "unpack.js"

VM-Install-Node-Tool-From-Zip $toolName $category $zipUrl $zipSha256 -command $command
