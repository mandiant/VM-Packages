$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'PEAnatomist'
$category = 'PE'

$zipUrl = 'https://rammerlabs.alidml.ru/files/0000-0002-29CD-0000/PEAnatomist-0.2.zip'
$zipSha256 = '8265abffa0f9e7ad4c3e2293b708c4cfda475407309e97b2437ec7121cd8668d'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false
