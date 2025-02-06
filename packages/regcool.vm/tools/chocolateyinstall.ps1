$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'RegCool'
$category = 'Registry'

$zipUrl = 'https://kurtzimmermann.com/files/RegCoolX64.zip'
$zipSha256 = '6514f05dacf360f1c1c968d3f5b0f89d3447b49ee55bd4e21935e6e29e3325ef'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
