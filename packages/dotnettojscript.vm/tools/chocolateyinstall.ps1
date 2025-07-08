$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotNetToJScript'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/tyranid/DotNetToJScript/archive/4dbe155912186f9574cb1889386540ba0e80c316.zip'
$zipSha256 = '12566bdfced108fafba97548c59c07be55988beb1c1e970e62bf40ddaebc4a0a'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
