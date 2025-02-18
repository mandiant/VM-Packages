$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ADConnectDump'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/fox-it/adconnectdump/archive/3ff6ebe7afac83263dd41857fdec51dcca0012b4.zip'
$zipSha256 = '6f36659f4d0ef7e20ddea0d7c17f36786c2fa8ca0728e6fd790f3234f408e0e9'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
