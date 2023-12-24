$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'DotNetToJScript'
$category = 'Payload Development'

$zipUrl = 'https://github.com/tyranid/DotNetToJScript/archive/4dbe155912186f9574cb1889386540ba0e80c316.zip'
$zipSha256 = '12566bdfced108fafba97548c59c07be55988beb1c1e970e62bf40ddaebc4a0a'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
