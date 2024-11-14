$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'SystemInformer'
$category = 'Utilities'

$zipUrl = 'https://github.com/winsiderss/si-builds/releases/download/3.1.24318/systeminformer-3.1.24318-release-bin.zip'
$zipSha256 = '8b98aacbd993e1193379c93d9adc1935869ee0dfcf9783118ac60610b674a995'
$executableName = "amd64\$toolName.exe"

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -executableName $executableName -consoleApp $false
