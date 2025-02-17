$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'C3'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/WithSecureLabs/C3/archive/e1b9922d199e45e222001a3afe47757349f24e7a.zip'
$zipSha256 = '8dd29ed32c2a38312b617c430ff84019da8bd434e3704b778f031aaa859c4e8e'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
