$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PayloadAllTheThings'
$category = 'Wordlists'

$zipUrl = 'https://github.com/swisskyrepo/PayloadsAllTheThings/archive/cd19bb94096a61ef22d0c9668bc29674fce53fa0.zip'
$zipSha256 = 'c2adbecb78e01e5d8987ab42b40a30b4a104ee6c2886d8143395645408f9f361'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
