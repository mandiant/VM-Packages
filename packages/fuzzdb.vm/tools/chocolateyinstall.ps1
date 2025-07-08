$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'FuzzDB'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://github.com/fuzzdb-project/fuzzdb/archive/5656ab25dc6bb43bae32236fab775658a90d7380.zip'
$zipSha256 = 'b732136975be06f71e8c8cfa6923a6dfba028b7f8c4cfa21c6280ef5b74aa1fa'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
