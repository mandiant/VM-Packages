$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'shellcode_launcher'
$category = 'Shellcode'

$exeUrl = 'https://github.com/clinicallyinane/shellcode_launcher/raw/7f55d42a9253c58083d163512e23019df0573420/shellcode_launcher.exe'
$exeSha256 = 'fc7c0272170b52c907f316d6fde0a9fe39300678d4a629fa6075e47d7f525b67'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256
