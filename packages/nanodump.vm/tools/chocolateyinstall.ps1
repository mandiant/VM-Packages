$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'NanoDump'
$category = 'Credential Access'

$zipUrl = 'https://github.com/fortra/nanodump/archive/c211c5f72b2438afb09d0eb917fe32150be91344.zip'
$zipSha256 = '461a16ae517aebb65adc37a0da8f8c04fa4836da35a69239dc2f90f8098b5da0'

VM-Install-Raw-GitHub-Repo $toolName $category $zipUrl $zipSha256
