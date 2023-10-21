$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'C3'
$category = 'Command & Control'

$zipUrl = 'https://github.com/WithSecureLabs/C3/archive/e1b9922d199e45e222001a3afe47757349f24e7a.zip'
$zipSha256 = '8dd29ed32c2a38312b617c430ff84019da8bd434e3704b778f031aaa859c4e8e'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
