$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'binwalk'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

# Temporary workaround until official repo publishes a release automatically, replace with official URL when available
# Note: The official binwalk repository does not currently provide a Windows binary.
# This script uses a pre-built binary from a third-party source.
# Replace with https://github.com/ReFirmLabs/binwalk when they provide a Windows binary.
$zipUrl = 'https://github.com/socketz/binwalk/releases/download/v3.1.1/binwalk-Windows-msvc-x86_64.zip'
$zipSha256 = '5418e2d88af47d89b7f5fe47449d47acdf1ded1aabdccc582aabbbca6d39da89'
$arguments = ''

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -arguments $arguments