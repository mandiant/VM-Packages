$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Whisker'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/eladshamir/Whisker/archive/0bc2a0acc4a92b49c69d873f7ac565340a5f3291.zip'
$zipSha256 = 'b181b639f2d18fb37e045d27cbe522e7b97aaa85c30dc0cb9bc75eaf6b939f9a'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
