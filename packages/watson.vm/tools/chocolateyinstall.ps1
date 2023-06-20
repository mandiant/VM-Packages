$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Watson'
$category = 'Information Gathering'

$zipUrl = 'https://github.com/rasta-mouse/Watson/archive/ad7895e7e5fe205bf79f5a32181dff4ba136827b.zip'
$zipSha256 = 'dc08d7a9621c81488d941b59711d042559a5b3af10f477549ff0cf085cf5f97a'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
