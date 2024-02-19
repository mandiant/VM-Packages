$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ExtremeDumper'
$category = 'dotNet'

$zipUrl = 'https://github.com/wwh1004/ExtremeDumper/releases/latest/download/ExtremeDumper.zip'
$zipSha256 = 'fbffedf2a9420be03538f04bd80a69e35503f8d8395da76a9ac2518a65e1facc'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
