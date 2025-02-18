$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'ExtremeDumper'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$zipUrl = 'https://gitee.com/keyestore/ExtremeDumper/releases/download/v4.0.0.1/ExtremeDumper.zip'
$zipSha256 = 'fbffedf2a9420be03538f04bd80a69e35503f8d8395da76a9ac2518a65e1facc'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $false -innerFolder $false
