$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'StreamDivert'
$category = 'Networking'

$zipUrl = 'https://github.com/jellever/StreamDivert/releases/download/v1.1/StreamDivert.x64.zip'
$zipSha256 = '88df0ee37e817555fa24520a421f1c122a67349a20f8bbde0c027f3e6fdf54b1'

VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256
