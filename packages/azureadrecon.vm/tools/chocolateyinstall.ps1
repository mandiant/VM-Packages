$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'AzureADRecon'
$category = 'Cloud'

$zipUrl = 'https://github.com/adrecon/AzureADRecon/archive/18410c1a630c085091ad15a768ac742fd2513902.zip'
$zipSha256 = '51e0af14ae0e35300fe6fe8fa96ebbce86abb34a597fe81fd16b7358ebe13aae'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
