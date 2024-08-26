$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'JLECmd'
$category = 'Forensic'

$zipUrl = 'https://download.mikestammer.com/net6/JLECmd.zip'
$zipSha256 = 'b0635517a72d2a7cdfdc92d5161f38e968380ae2ec33673571108bacf31b4480'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false
