$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'GadgetToJScript'
$category = 'Payload Development'

$zipUrl = 'https://github.com/med0x2e/GadgetToJScript/archive/98f50984015c29eecb11c6c4ddc3c2cc3a6669da.zip'
$zipSha256 = '093451115744beec90e7de4efc61857361b56d16a3a31d78182a8c7ef675938b'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
