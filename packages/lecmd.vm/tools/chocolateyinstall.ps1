$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'LECmd'
$category = 'Utilities'

$zipUrl = "https://f001.backblazeb2.com/file/EricZimmermanTools/LECmd.zip"
$zipSha256 = "a7f694d3aeb958cf18efba2e32c3e590fbd6a8e358d0117f66294f36d5425203"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true

