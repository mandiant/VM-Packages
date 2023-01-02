$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'scdbg'
$category = 'Debuggers'

$zipUrl = 'https://github.com/dzzie/VS_LIBEMU/releases/download/12.7.22/VS_LIBEMU_12_7_22.zip'
$zipSha256 = '521130E34CC0A30587FF99D030633B9D124CCAC779A213E15025535171B4113D'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
