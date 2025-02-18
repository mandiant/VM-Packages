$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'Situational Awareness BOF'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://codeload.github.com/trustedsec/CS-Situational-Awareness-BOF/zip/9a813b8f31cd397d7b05211e1d5b378c07fd1b8b'
$zipSha256 = 'b461e5a0dde271ee29c2105f8b064e6c3d38f4996c09478c16bb1f071cee00c1'

# This tool does not have a `.exe` associated with it, so this links it to the directory
VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 -withoutBinFile -innerFolder $true
